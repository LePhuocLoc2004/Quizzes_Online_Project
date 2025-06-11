// Validate quizData
if (typeof window.quizData === 'undefined') {
  alert('Quiz data not found!');
  throw new Error('Quiz data must be defined before initializing the quiz.');
}

// Core State & Elements
const elements = {
  questionBtns: document.querySelectorAll('.question-btn'),
  currentQuestionSpan: document.getElementById('current-question'),
  answeredCount: document.getElementById('answered-count'),
  markedCount: document.getElementById('marked-count'),
  progressAnswered: document.getElementById('progress-answered'),
  progressMarked: document.getElementById('progress-marked'),
  prevBtn: document.getElementById('prev-question'),
  nextBtn: document.getElementById('next-question'),
  markBtn: document.getElementById('mark-review'),
  timer: document.getElementById('timer'),
  submitBtn: document.getElementById('submit-quiz'),
};

const quizState = {
  currentQuestion: 1,
  totalQuestions: window.quizData.totalQuestions,
  answeredQuestions: new Set(),
  markedQuestions: new Set(),
  isTransitioning: false,
};

const quiz = {
  init() {
    this.loadExistingAttempt();
    this.setupEventListeners();
    this.startTimer(window.quizData.timeLimit);
  },

  async loadExistingAttempt() {
    try {
      const response = await fetch(`/take-quiz/${window.quizData.quizId}/attempt/${window.quizData.attemptId}`);
      const attempt = await response.json();

      if (attempt) {
        // Restore answered questions
        if (attempt.userAnswers) {
          attempt.userAnswers.forEach((answer) => {
            const questionNum = this.getQuestionNumberById(answer.questionId);
            if (questionNum) {
              quizState.answeredQuestions.add(questionNum);
              if (answer.questionType === 'MULTIPLE_CHOICE') {
                answer.answerIds.forEach((answerId) => {
                  const input = document.querySelector(`input[name="q${answer.questionId}"][value="${answerId}"]`);
                  if (input) input.checked = true;
                });
              } else {
                const input = document.querySelector(
                  `input[name="q${answer.questionId}"][value="${answer.answerIds[0]}"]`
                );
                if (input) input.checked = true;
              }
            }
          });
        }

        // Update timer if provided
        if (attempt.remainingTime !== undefined) {
          window.quizData.timeLimit = attempt.remainingTime;
        }

        // Restore marked questions
        if (attempt.markedQuestions && Array.isArray(attempt.markedQuestions)) {
          attempt.markedQuestions.forEach((questionNum) => {
            quizState.markedQuestions.add(parseInt(questionNum));
          });
        }

        this.updateAllUI();
      }
    } catch (error) {
      console.error('Error loading attempt:', error);
    }
  },

  // Helper to find question number from ID
  getQuestionNumberById(questionId) {
    const questionElement = document.querySelector(`input[name="q${questionId}"]`);
    if (questionElement) {
      const questionContent = questionElement.closest('.question-content');
      return parseInt(questionContent.id.split('-')[1]);
    }
    return null;
  },

  // UI update method
  updateAllUI() {
    this.updateProgress();
    elements.questionBtns.forEach((btn) => {
      this.updateQuestionButton(parseInt(btn.dataset.question));
    });
    this.updateNavigationButtons(quizState.currentQuestion);
    elements.currentQuestionSpan.textContent = quizState.currentQuestion;

    const currentQuestionElem = document.getElementById(`question-${quizState.currentQuestion}`);
    if (currentQuestionElem) {
      document.querySelectorAll('.question-content').forEach((q) => (q.style.display = 'none'));
      currentQuestionElem.style.display = '';
    }
  },

  // Update single question button state
  updateQuestionButton(questionNum) {
    const btn = document.querySelector(`[data-question="${questionNum}"]`);
    if (!btn) return;

    // Reset button class
    btn.className = 'question-btn';

    // Apply classes in correct order
    if (quizState.answeredQuestions.has(questionNum)) btn.classList.add('answered');
    if (quizState.markedQuestions.has(questionNum)) btn.classList.add('marked');
    if (questionNum === quizState.currentQuestion) btn.classList.add('current');
  },

  // Update progress indicators
  updateProgress() {
    const answeredCount = quizState.answeredQuestions.size;
    const markedCount = quizState.markedQuestions.size;
    const totalQuestions = quizState.totalQuestions;

    elements.answeredCount.textContent = answeredCount;
    elements.markedCount.textContent = markedCount;

    const answeredPercent = (answeredCount / totalQuestions) * 100;
    const markedPercent = (markedCount / totalQuestions) * 100;

    elements.progressAnswered.style.width = `${answeredPercent}%`;
    elements.progressMarked.style.width = `${markedPercent}%`;
  },

  // Update navigation buttons based on current question
  updateNavigationButtons(questionNum) {
    elements.prevBtn.disabled = questionNum === 1;
    elements.nextBtn.disabled = questionNum === quizState.totalQuestions;
  },

  // Event Listeners
  setupEventListeners() {
    // Question button navigation - IMPROVED
    elements.questionBtns.forEach((btn) => {
      // Remove any existing listeners to prevent duplicates
      const oldBtn = btn.cloneNode(true);
      btn.parentNode.replaceChild(oldBtn, btn);

      // Add enhanced click event
      oldBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        const questionNum = parseInt(e.currentTarget.dataset.question);
        if (!isNaN(questionNum) && questionNum > 0) {
          this.navigateToQuestion(questionNum);
        }
      });
    });

    // Update elements reference after replacing buttons
    elements.questionBtns = document.querySelectorAll('.question-btn');

    // Answer handling
    document.querySelectorAll('input[type="radio"], input[type="checkbox"]').forEach((input) => {
      input.addEventListener('change', (e) => this.handleAnswerSelection(e));
    });

    // Navigation buttons
    elements.prevBtn.addEventListener('click', () => {
      this.navigateToQuestion(quizState.currentQuestion - 1);
    });

    elements.nextBtn.addEventListener('click', () => {
      this.navigateToQuestion(quizState.currentQuestion + 1);
    });

    // Mark question for review
    elements.markBtn.addEventListener('click', () => this.toggleMarkQuestion());

    // Submit handlers
    elements.submitBtn.addEventListener('click', () => this.showSubmitConfirm());
    document.getElementById('confirm-submit').addEventListener('click', () => this.submitQuiz());
    document.getElementById('submit-timeout').addEventListener('click', () => this.handleTimeout());

    // Add ripple effect for question buttons
    elements.questionBtns.forEach((btn) => {
      btn.addEventListener('mousedown', function (e) {
        const x = e.clientX - this.getBoundingClientRect().left;
        const y = e.clientY - this.getBoundingClientRect().top;

        const ripple = document.createElement('span');
        ripple.className = 'ripple';
        ripple.style.left = `${x}px`;
        ripple.style.top = `${y}px`;

        this.appendChild(ripple);

        setTimeout(() => {
          ripple.remove();
        }, 600);
      });
    });
  },

  //  navigations method
  navigateToQuestion(questionNum) {
    if (
      questionNum === quizState.currentQuestion ||
      questionNum < 1 ||
      questionNum > quizState.totalQuestions ||
      quizState.isTransitioning
    ) {
      return;
    }

    quizState.isTransitioning = true;

    const currentQuestion = document.getElementById(`question-${quizState.currentQuestion}`);
    const newQuestion = document.getElementById(`question-${questionNum}`);

    if (!newQuestion || !currentQuestion) {
      quizState.isTransitioning = false;
      return;
    }

    // Hide current question
    currentQuestion.style.display = 'none';

    // Show new question
    newQuestion.style.display = '';

    // Update UI state
    elements.currentQuestionSpan.textContent = questionNum;

    // Update question grid buttons
    elements.questionBtns.forEach((btn) => {
      const btnNum = parseInt(btn.dataset.question);
      btn.classList.remove('current');

      if (quizState.answeredQuestions.has(btnNum)) {
        btn.classList.add('answered');
      } else {
        btn.classList.remove('answered');
      }
      if (quizState.markedQuestions.has(btnNum)) {
        btn.classList.add('marked');
      } else {
        btn.classList.remove('marked');
      }
      if (btnNum === questionNum) {
        btn.classList.add('current');
      }
    });

    // Update navigation buttons
    this.updateNavigationButtons(questionNum);

    // Update state
    quizState.currentQuestion = questionNum;

    // Reset transition lock after a short delay
    setTimeout(() => {
      quizState.isTransitioning = false;
    }, 50);
  },

  // Handle answer selection
  async handleAnswerSelection(event) {
    const input = event.target;
    const questionContent = input.closest('.question-content');
    if (!questionContent) return;
    const questionId = input.name.replace('q', '');
    const questionType = questionContent.dataset.questionType;
    const questionNumber = parseInt(questionContent.id.split('-')[1]);

    try {
      // Disable inputs while saving
      const inputs = questionContent.querySelectorAll('input');
      inputs.forEach((input) => (input.disabled = true));
      let selectedAnswerIds;
      if (questionType === 'MULTIPLE_CHOICE') {
        selectedAnswerIds = Array.from(questionContent.querySelectorAll('input:checked')).map((input) =>
          parseInt(input.value)
        );
      } else {
        selectedAnswerIds = [parseInt(input.value)];
      }

      await this.saveUserAnswer({
        attemptId: window.quizData.attemptId,
        questionId: parseInt(questionId),
        answerIds: selectedAnswerIds,
      });

      // Update UI
      quizState.answeredQuestions.add(questionNumber);
      this.updateQuestionButton(questionNumber);
      this.updateProgress();
    } catch (error) {
      console.error('Error saving answer:', error);
    } finally {
      const inputs = questionContent.querySelectorAll('input');
      inputs.forEach((input) => (input.disabled = false));
    }
  },

  // API call to save user answer
  async saveUserAnswer(answerData) {
    const csrfToken = document.querySelector("meta[name='_csrf']").content;
    const csrfHeaderName = document.querySelector("meta[name='_csrf_header']").content;

    const response = await fetch(`/take-quiz/${window.quizData.quizId}/answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        [csrfHeaderName]: csrfToken,
      },
      body: JSON.stringify(answerData),
    });

    if (!response.ok) {
      throw new Error('Failed to save answer');
    }

    return await response.json();
  },

  // Toggle mark status for current question
  toggleMarkQuestion() {
    const currentNum = quizState.currentQuestion;
    const cacheKey = `marked_questions_${quizData.quizId}_${quizData.attemptId}`;
    if (quizState.markedQuestions.has(currentNum)) {
      quizState.markedQuestions.delete(currentNum);
    } else {
      quizState.markedQuestions.add(currentNum);
    }
    localStorage.setItem(cacheKey, JSON.stringify([...quizState.markedQuestions]));
    this.updateQuestionButton(currentNum);
    this.updateProgress();
  },

  // Start timer countdown
  startTimer(totalSeconds) {
    const startTime = Date.now();
    const endTime = startTime + totalSeconds * 1000;

    const timer = setInterval(() => {
      const now = Date.now();
      const remaining = Math.max(0, Math.floor((endTime - now) / 1000));

      if (remaining <= 0) {
        clearInterval(timer);
        elements.timer.textContent = '0:00';
        this.showTimeoutModal();
        return;
      }

      const mins = Math.floor(remaining / 60);
      const secs = remaining % 60;
      elements.timer.textContent = `${mins}:${secs.toString().padStart(2, '0')}`;

      // Add warning classes for low time
      if (remaining <= 300) {
        // 5 minutes
        elements.timer.classList.add('text-danger');
      }
      if (remaining <= 60) {
        // 1 minute
        elements.timer.classList.add('text-danger', 'blink');
      }
    }, 1000);

    this.timerInterval = timer;
  },

  // Show timeout modal
  showTimeoutModal() {
    // Clear timer interval
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
    }

    this.disableQuizInteraction();

    // Update statistics
    const answeredCount = quizState.answeredQuestions.size;
    const totalQuestions = quizState.totalQuestions;

    document.getElementById('answered-count-timeout').textContent = answeredCount;
    document.getElementById('total-questions-timeout').textContent = totalQuestions;

    const timeoutModal = new bootstrap.Modal(document.getElementById('timeoutModal'));
    timeoutModal.show();
    document.getElementById('timeoutModal').addEventListener('hide.bs.modal', (e) => {
      e.preventDefault();
    });
  },

  showSubmitConfirm() {
    // Calculate statistics
    const answeredCount = quizState.answeredQuestions.size;
    const totalQuestions = quizState.totalQuestions;
    const unansweredCount = totalQuestions - answeredCount;
    const completionPercentage = Math.round((answeredCount / totalQuestions) * 100);

    // Update modal content with timeout protection
    try {
      document.getElementById('answered-count-modal').textContent = answeredCount;
      document.getElementById('total-questions-modal').textContent = totalQuestions;
      document.getElementById('unanswered-count-modal').textContent = unansweredCount;
      document.getElementById('remaining-time-modal').textContent = elements.timer.textContent;
      document.getElementById('progress-percentage').textContent = `${completionPercentage}%`;

      // Update progress ring
      const progressRingPath = document.getElementById('progress-ring-path');
      if (progressRingPath) {
        const circumference = 2 * Math.PI * 15.9155;
        const offset = circumference * (1 - completionPercentage / 100);
        progressRingPath.style.strokeDasharray = `${circumference - offset} ${circumference}`;
      }
      const modal = new bootstrap.Modal(document.getElementById('submitConfirmModal'));
      modal.show();

      // Add animation after modal is shown
      setTimeout(() => {
        const statItems = document.querySelectorAll('.submit-statistics .stat-item');
        statItems.forEach((item, index) => {
          item.style.opacity = '0';
          item.style.transform = 'translateY(10px)';
          item.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
          setTimeout(() => {
            item.style.opacity = '1';
            item.style.transform = 'translateY(0)';
          }, 100 + index * 100);
        });
      }, 300);
    } catch (error) {
      console.error('Error showing submit confirmation:', error);
      const answeredCount = quizState.answeredQuestions.size;
      const totalQuestions = quizState.totalQuestions;
      alert(
        `Submit Quiz?\n\nAnswered: ${answeredCount}/${totalQuestions} questions\nRemaining time: ${elements.timer.textContent}`
      );
    }
  },

  //submit quiz method
  async submitQuiz() {
    try {
      const submitBtn = document.getElementById('confirm-submit');
      const progressRing = document.getElementById('progress-ring-path');
      const confirmationMessage = document.querySelector('.submit-confirmation-message .alert');

      this.disableQuizInteraction();
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';
      }

      const csrfToken = document.querySelector("meta[name='_csrf']").content;
      const csrfHeaderName = document.querySelector("meta[name='_csrf_header']").content;

      // Submit quiz
      const response = await fetch(`/take-quiz/${window.quizData.quizId}/submit`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          [csrfHeaderName]: csrfToken,
        },
        body: JSON.stringify({
          attemptId: window.quizData.attemptId,
        }),
      });

      const result = await response.json();

      if (result.status === 'SUCCESS') {
        if (progressRing) progressRing.style.stroke = '#10b981';
        if (confirmationMessage) {
          confirmationMessage.className = 'alert alert-success';
          confirmationMessage.innerHTML =
            '<i class="fas fa-check-circle me-2"></i>Quiz submitted successfully! Redirecting...';
        }
        localStorage.removeItem(`marked_questions_${window.quizData.quizId}_${window.quizData.attemptId}`);
        setTimeout(() => {
          window.location.href = `/take-quiz/quiz-review/${window.quizData.attemptId}`;
        }, 1500);
      } else {
        throw new Error(result.message || 'Failed to submit quiz');
      }
    } catch (error) {
      console.error('Submit error:', error);
      const confirmationMessage = document.querySelector('.submit-confirmation-message .alert');
      if (confirmationMessage) {
        confirmationMessage.className = 'alert alert-danger';
        confirmationMessage.innerHTML = `<i class="fas fa-exclamation-triangle me-2"></i>${error.message}`;
      }

      // Re-enable submit button
      const submitBtn = document.getElementById('confirm-submit');
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Submit Quiz';
      }
    }
  },

  // Handle timeout
  async handleTimeout() {
    try {
      const timeoutBtn = document.getElementById('submit-timeout');
      if (!timeoutBtn) return;
      timeoutBtn.disabled = true;
      timeoutBtn.classList.add('loading');
      timeoutBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Processing...';

      const csrfToken = document.querySelector("meta[name='_csrf']").content;
      const csrfHeaderName = document.querySelector("meta[name='_csrf_header']").content;

      const response = await fetch(`/take-quiz/${window.quizData.quizId}/timeout`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          [csrfHeaderName]: csrfToken,
        },
        body: JSON.stringify({
          attemptId: window.quizData.attemptId,
        }),
      });

      if (!response.ok) throw new Error('Failed to handle timeout');
      const result = await response.json();
      if (result.status === 'SUCCESS') {
        localStorage.removeItem(`marked_questions_${window.quizData.quizId}_${window.quizData.attemptId}`);
        // Update button to show success state before redirect
        timeoutBtn.classList.remove('loading');
        timeoutBtn.innerHTML = '<i class="fas fa-check-circle"></i> Success!';

        // Redirect after a short delay
        setTimeout(() => {
          window.location.href = `/take-quiz/quiz-review/${window.quizData.attemptId}`;
        }, 1000);
      } else {
        throw new Error(result.message);
      }
    } catch (error) {
      console.error('Timeout error:', error);

      // Reset button state and show error
      const timeoutBtn = document.getElementById('submit-timeout');
      if (timeoutBtn) {
        timeoutBtn.disabled = false;
        timeoutBtn.classList.remove('loading');
        timeoutBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Submit Quiz';
      }
      alert('Error processing timeout. Please try again.');
    }
  },

  disableQuizInteraction() {
    document.querySelectorAll('input').forEach((input) => (input.disabled = true));
    document.querySelectorAll('.nav-button').forEach((btn) => (btn.disabled = true));
    document.querySelectorAll('.question-btn').forEach((btn) => {
      btn.classList.add('disabled');
      btn.style.pointerEvents = 'none';
    });
    // Add overlay to prevent interactions
    const overlay = document.createElement('div');
    overlay.className = 'quiz-overlay';
    document.body.appendChild(overlay);
  },
};

// Initialize on load
document.addEventListener('DOMContentLoaded', () => quiz.init());
