const container = document.getElementById('container');
const registerBtn = document.getElementById('register');
const loginBtn = document.getElementById('login');

// Chuyển đổi sang Sign Up
registerBtn.addEventListener('click', () => {
	container.classList.add("active");
});

// Chuyển đổi sang Sign In
loginBtn.addEventListener('click', () => {
	container.classList.remove("active");
});

// Validation cho form Sign Up
document.querySelector('.sign-up form').addEventListener('submit', (e) => {
	const password = document.getElementById('password').value;
	const confirmPassword = document.getElementById('confirmPassword').value;

	if (password !== confirmPassword) {
		e.preventDefault(); // Ngăn form gửi đi
		alert('Passwords do not match!'); // Thông báo lỗi
	}
});