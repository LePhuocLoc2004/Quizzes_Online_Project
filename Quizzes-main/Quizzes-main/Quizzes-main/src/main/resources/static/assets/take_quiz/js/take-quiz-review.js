document.addEventListener('DOMContentLoaded', () => {
  const state = {
    currentQuestion: 1,
    totalQuestions: window.quizResult.totalQuestions,
  };

  const elements = {
    questionBtns: document.querySelectorAll('.question-btn'),
    prevBtn: document.getElementById('prev-question'),
    nextBtn: document.getElementById('next-question'),
  };

  function updateNavigation(questionNum) {
    elements.prevBtn.disabled = questionNum === 1;
    elements.nextBtn.disabled = questionNum === state.totalQuestions;
    document.getElementById('current-question').textContent = questionNum;
  }

  function showQuestion(questionNum) {
    // Hide all questions
    document.querySelectorAll('.question-content').forEach((q) => (q.style.display = 'none'));

    // Show selected question
    const questionToShow = document.getElementById(`question-${questionNum}`);
    if (questionToShow) {
      questionToShow.style.display = '';
    }

    // Update buttons
    elements.questionBtns.forEach((btn) => {
      btn.classList.toggle('current', parseInt(btn.dataset.question) === questionNum);
    });

    // Update navigation
    updateNavigation(questionNum);

    state.currentQuestion = questionNum;
  }

  // Event Listeners
  elements.questionBtns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
      const questionNum = parseInt(e.target.dataset.question);
      showQuestion(questionNum);
    });
  });

  elements.prevBtn.addEventListener('click', () => {
    if (state.currentQuestion > 1) {
      showQuestion(state.currentQuestion - 1);
    }
  });

  elements.nextBtn.addEventListener('click', () => {
    if (state.currentQuestion < state.totalQuestions) {
      showQuestion(state.currentQuestion + 1);
    }
  });

  // Initialize
  showQuestion(1);
});
