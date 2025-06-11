# Kế Hoạch Phát Triển Ứng Dụng Trắc Nghiệm (Web MVC)

## 1. Module Authentication, Thống Kê & Quản Lý (ADMIN)

### Controller Tasks

- [ ] AdminController: Quản lý dashboard admin
- [ ] UserManagementController: CRUD người dùng
- [ ] QuizManagementController: CRUD quiz và câu hỏi
- [ ] StatisticsController: Xem thống kê tổng quan

### View Tasks

- [ ] admin/dashboard.html: Trang tổng quan
- [ ] admin/users/index.html: Danh sách user
- [ ] admin/users/form.html: Form thêm/sửa user
- [ ] admin/quizzes/index.html: Danh sách quiz
- [ ] admin/quizzes/form.html: Form thêm/sửa quiz
- [ ] admin/questions/form.html: Form thêm/sửa câu hỏi
- [ ] admin/statistics/overview.html: Báo cáo thống kê

## 2. Module Quản Lý Bài Quiz (USER)

### Controller Tasks

- [ ] QuizController: Hiển thị và quản lý quiz của user
- [ ] UserQuizManagementController: CRUD quiz cá nhân

### View Tasks

- [ ] Danh sách quiz của user
- [ ] Tạo quiz mới
- [ ] Chỉnh sửa quiz
- [ ] Quản lý câu hỏi trong quiz

## 3. Module Chức Năng Thi Trắc Nghiệm

### Controller Tasks

- [ ] ExamController: Xử lý quá trình thi
- [ ] QuizAttemptController: Quản lý lượt thi

### View Tasks

- [ ] Danh sách quiz có thể thi
- [ ] Giao diện làm bài thi
- [ ] Xem lại bài thi
- [ ] Kết quả thi

### Service Tasks

- [ ] QuizSessionService: Xử lý phiên thi
- [ ] TimerService: Quản lý thời gian thi
- [ ] ScoreCalculationService: Tính điểm

## 4. Module Thống Kê & Xếp Hạng (USER)

### Controller Tasks

- [ ] UserStatisticsController: Thống kê cá nhân
- [ ] LeaderboardController: Xếp hạng

### View Tasks

- [ ] my-progress.html: Tiến độ học tập
- [ ] quiz-history.html: Lịch sử làm bài
- [ ] performance.html: Hiệu suất học tập
- [ ] index.html: Bảng xếp hạng
