document.addEventListener('DOMContentLoaded', function () {
  const quizState = {
    currentQuestion: 1,
    totalQuestions: 30,
    answers: new Map(),
    timeLeft: 45 * 60, // 45 minutes in seconds
  };

  initializeTimer(quizState);
  initializeNavigation(quizState);
  initializeAnswerTracking(quizState);
  initializeSubmitHandler(quizState);
});

function initializeTimer(state) {
  const timerElement = document.getElementById('timer');

  const timer = setInterval(() => {
    const minutes = Math.floor(state.timeLeft / 60);
    const seconds = state.timeLeft % 60;

    timerElement.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;

    if (state.timeLeft <= 300) {
      // Last 5 minutes
      timerElement.classList.add('text-danger');
    }

    if (--state.timeLeft < 0) {
      clearInterval(timer);
      submitQuiz(state);
    }
  }, 1000);
}

function initializeNavigation(state) {
  // Handle navigation button clicks
  document.querySelectorAll('.question-nav button').forEach((button) => {
    button.addEventListener('click', () => {
      const questionNum = parseInt(button.dataset.question);
      navigateToQuestion(questionNum, state);
    });
  });

  // Next/Prev buttons
  document
    .getElementById('next-question')
    ?.addEventListener('click', () => navigateToQuestion(state.currentQuestion + 1, state));

  document
    .getElementById('prev-question')
    ?.addEventListener('click', () => navigateToQuestion(state.currentQuestion - 1, state));
}

function navigateToQuestion(questionNum, state) {
  if (questionNum < 1 || questionNum > state.totalQuestions) return;

  // Hide current question
  document.querySelector(`#question-${state.currentQuestion}`).style.display = 'none';
  document.querySelector(`[data-question="${state.currentQuestion}"]`).classList.remove('current');

  // Show target question
  document.querySelector(`#question-${questionNum}`).style.display = 'block';
  document.querySelector(`[data-question="${questionNum}"]`).classList.add('current');

  state.currentQuestion = questionNum;

  // Update button states
  document.getElementById('prev-question').disabled = questionNum === 1;
  document.getElementById('next-question').disabled = questionNum === state.totalQuestions;
}

function initializeAnswerTracking(state) {
  document.querySelectorAll('input[type="radio"]').forEach((input) => {
    input.addEventListener('change', (e) => {
      const questionId = parseInt(e.target.name.replace('q', ''));
      state.answers.set(questionId, e.target.value);

      // Update navigation button to show answered state
      document.querySelector(`[data-question="${questionId}"]`).classList.add('answered');

      // Update progress bar
      updateProgress(state);
    });
  });
}

function updateProgress(state) {
  const progress = (state.answers.size / state.totalQuestions) * 100;
  const progressBar = document.getElementById('progress');
  if (progressBar) {
    progressBar.style.width = `${progress}%`;
    progressBar.textContent = `${state.answers.size}/${state.totalQuestions}`;
  }
}

function initializeSubmitHandler(state) {
  document.getElementById('submit-quiz')?.addEventListener('click', (e) => {
    e.preventDefault();

    const unanswered = state.totalQuestions - state.answers.size;
    if (unanswered > 0) {
      if (!confirm(`Bạn còn ${unanswered} câu chưa trả lời. Bạn có chắc muốn nộp bài?`)) {
        return;
      }
    }

    submitQuiz(state);
  });
}

function submitQuiz(state) {
  const submitButton = document.getElementById('submit-quiz');
  submitButton.disabled = true;
  submitButton.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang nộp bài...';

  const submissionData = {
    answers: Array.from(state.answers.entries()),
    timeSpent: 45 * 60 - state.timeLeft,
    timestamp: new Date().toISOString(),
  };

  // Simulate submission - replace with actual API call
  console.log('Submitting quiz:', submissionData);
  setTimeout(() => {
    window.location.href = 'quiz-result.html';
  }, 1500);
}
