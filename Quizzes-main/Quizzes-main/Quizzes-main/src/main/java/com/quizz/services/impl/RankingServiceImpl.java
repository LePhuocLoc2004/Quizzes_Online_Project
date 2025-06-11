package com.quizz.services.impl;

import com.quizz.dtos.quiz.RankingDTO;
import com.quizz.entities.Rankings;
import com.quizz.repositories.RankingRepository;
import com.quizz.services.RankingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class RankingServiceImpl implements RankingService {

    @Autowired
    private RankingRepository rankingRepository;

    @Override
    public List<RankingDTO> getAllRankings() {
        List<Rankings> rankings = rankingRepository.findAll();
        return rankings.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    private RankingDTO mapToDTO(Rankings ranking) {
        RankingDTO rankingDTO = new RankingDTO();
        rankingDTO.setRankingId(ranking.getRankingId());     
        // Lấy userId từ Users thông qua quan hệ @ManyToOne
        rankingDTO.setUserId(ranking.getUsers() != null ? ranking.getUsers().getUserId() : null);       
        // Lấy username từ Users nếu cần (tùy thuộc vào yêu cầu UI)
        rankingDTO.setUsername(ranking.getUsers() != null ? ranking.getUsers().getUsername() : null);    
        // Lấy profileImage từ Users để hiển thị avatar
        rankingDTO.setProfileImage(ranking.getUsers() != null ? ranking.getUsers().getProfileImage() : "default-avatar.png");  
        rankingDTO.setTotalScore(ranking.getTotalScore() != null ? ranking.getTotalScore() : 0);
        rankingDTO.setQuizzesCompleted(ranking.getQuizzesCompleted() != null ? ranking.getQuizzesCompleted() : 0);
        rankingDTO.setCorrectAnswers(ranking.getCorrectAnswers() != null ? ranking.getCorrectAnswers() : 0);
        rankingDTO.setRankPosition(ranking.getRankPosition());
        rankingDTO.setUpdatedAt(ranking.getUpdatedAt());
        rankingDTO.setCreatedAt(ranking.getCreatedAt());
        
        return rankingDTO;
    }


	@Override
	public List<RankingDTO> getTop3Rankings(List<RankingDTO> rankings) {
	    return rankings.stream()
	            .sorted(Comparator.comparingInt(RankingDTO::getTotalScore).reversed()) // Sắp xếp theo điểm giảm dần
	            .limit(3) // Giới hạn chỉ lấy 3 phần tử
	            .collect(Collectors.toList());
	}

	@Override
	public List<RankingDTO> getRankingsByTimeFilter(String timeFilter) {
	    LocalDate now = LocalDate.now();
	    LocalDate startDate = null;

	    if ("week".equalsIgnoreCase(timeFilter)) {
	        startDate = now.minusWeeks(1); // Lọc dữ liệu của tuần trước
	    } else if ("month".equalsIgnoreCase(timeFilter)) {
	        startDate = now.minusMonths(1); // Lọc dữ liệu của tháng trước
	    }

	    // Lấy toàn bộ danh sách xếp hạng từ database
	    List<Rankings> rankings = rankingRepository.findAll();

	    // Nếu có bộ lọc thời gian, chỉ lấy những bản ghi trong khoảng thời gian đó
	    if (startDate != null) {
	        LocalDate filterDate = startDate;
	        rankings = rankings.stream()
	                .filter(r -> r.getCreatedAt().toInstant()
	                        .atZone(ZoneId.systemDefault()).toLocalDate()
	                        .isAfter(filterDate)) // Lọc theo thời gian trước
	                .collect(Collectors.toList());
	    }

	    // Gom nhóm theo từng userId để lấy điểm số trong khoảng thời gian đó
	    Map<Long, RankingDTO> bestScoresByUser = rankings.stream()
	            .map(this::mapToDTO)
	            .collect(Collectors.toMap(
	                    RankingDTO::getUserId, 
	                    r -> r, 
	                    (existing, replacement) -> existing.getTotalScore() > replacement.getTotalScore() ? existing : replacement
	            ));

	    return bestScoresByUser.values().stream()
	            .sorted(Comparator.comparingInt(RankingDTO::getTotalScore).reversed()) // Sắp xếp lại theo điểm
	            .collect(Collectors.toList());
	}
}