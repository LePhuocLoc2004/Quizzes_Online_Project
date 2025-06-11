package com.quizz.controllers;

import com.quizz.entities.Categories;
import com.quizz.entities.Quizzes;
import com.quizz.services.QuizzesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/answer")
public class AnswerQuizzesController {

    
   final private QuizzesService quizzesService;
   
   public AnswerQuizzesController(QuizzesService _quizzesService){
	   this.quizzesService = _quizzesService;
   }

    @GetMapping("/list")
    public String listQuizzes(Model model,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "") String keyword,
                              @RequestParam(defaultValue = "") String categoryId,
                              @RequestParam(defaultValue = "") String fromDate,
                              Principal principal) {
        Pageable pageable = PageRequest.of(page - 1, 9); // 9 quiz mỗi trang

  
        Date dateFilter = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (!fromDate.isEmpty()) {
            try {
                if ("today".equals(fromDate)) {
                    dateFilter = new Date(); // Hôm nay
                } else if ("week".equals(fromDate)) {
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.DAY_OF_YEAR, -7);
                    dateFilter = cal.getTime(); // 7 ngày trước
                } else if ("month".equals(fromDate)) {
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.MONTH, -1);
                    dateFilter = cal.getTime(); // 1 tháng trước
                } else {
                    dateFilter = sdf.parse(fromDate); // Chuỗi yyyy-MM-dd từ client
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Lấy danh sách quiz phân trang với các bộ lọc
        Page<Quizzes> quizPage = quizzesService.getAllQuizzesSortedByCreatedAt(keyword, categoryId, dateFilter, pageable);

        // Lấy danh sách danh mục
        List<Categories> categories = quizzesService.getAllCategories();

        // Thêm dữ liệu vào model
        model.addAttribute("categories", categories);
        model.addAttribute("quizzes", quizPage.getContent());
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("fromDate", fromDate); // Giữ giá trị từ khóa thời gian (today, week, month)
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", quizPage.getTotalPages());

        // Thêm các giá trị ngày đã tính toán để hiển thị trong select
        model.addAttribute("todayDate", sdf.format(new Date()));
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_YEAR, -7);
        model.addAttribute("weekDate", sdf.format(cal.getTime()));
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1);
        model.addAttribute("monthDate", sdf.format(cal.getTime()));

        return "answer/quizList";
    }
}