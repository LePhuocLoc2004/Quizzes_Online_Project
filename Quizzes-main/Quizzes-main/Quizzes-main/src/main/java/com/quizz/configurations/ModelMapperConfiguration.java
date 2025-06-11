package com.quizz.configurations;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.quizz.api.minhthan.mapping.ApiModelMappingConfiguration;
import com.quizz.dtos.UserDTO;
import com.quizz.dtos.quiz.AnswerDTO;
import com.quizz.dtos.quiz.QuestionDTO;
import com.quizz.dtos.quiz.QuizDTO;
import com.quizz.entities.Answers;
import com.quizz.entities.Questions;
import com.quizz.entities.Quizzes;
import com.quizz.entities.Users;

@Configuration
public class ModelMapperConfiguration {

    @Bean
    public ModelMapper modelMapper() {
	ModelMapper mapper = new ModelMapper();
	mapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT).setSkipNullEnabled(true)
		.setFieldMatchingEnabled(true)
		.setFieldAccessLevel(org.modelmapper.config.Configuration.AccessLevel.PRIVATE);

	// Thêm converter cho Date
	mapper.addConverter(new org.modelmapper.AbstractConverter<Date, String>() {
	    @Override
	    protected String convert(Date source) {
		if (source == null) {
		    return null;
		}
		return new SimpleDateFormat("dd/MM/yyyy").format(source);
	    }
	});

	mapper.addConverter(new org.modelmapper.AbstractConverter<String, Date>() {
	    @Override
	    protected Date convert(String source) {
		try {
		    if (source == null) {
			return null;
		    }
		    return new SimpleDateFormat("dd/MM/yyyy").parse(source);
		} catch (Exception e) {
		    return null;
		}
	    }
	});

	configureUserMapping(mapper);
	configureQuizMapping(mapper);

	// import Take-quiz Mapping
	TakeQuizMapping.configureTakeQuizMapping(mapper);
	TakeQuizMapping.configureQuizAttemptMapping(mapper);
	TakeQuizMapping.configureQuizResultMapping(mapper);

  // import Api Mapping
  ApiModelMappingConfiguration.configureAllApiMappings(mapper);
	return mapper;
    }

   @Bean
    @Primary
    public BCryptPasswordEncoder passwordEncoder() {
	return new BCryptPasswordEncoder();
    }

    private void configureUserMapping(ModelMapper mapper) {
	mapper.createTypeMap(Users.class, UserDTO.class).addMapping(Users::getUserId, UserDTO::setUserId)
		.addMapping(Users::getUsername, UserDTO::setUsername).addMapping(Users::getEmail, UserDTO::setEmail)
		.addMapping(Users::getRole, UserDTO::setRole)
		.addMapping(Users::getProfileImage, UserDTO::setProfileImage)
		.addMapping(Users::getIsActive, UserDTO::setIsActive)
		.addMapping(Users::getCreatedAt, UserDTO::setCreatedAt)
		.addMappings(mapping -> mapping.skip(UserDTO::setPassword));

	mapper.createTypeMap(UserDTO.class, Users.class).addMapping(UserDTO::getUserId, Users::setUserId)
		.addMapping(UserDTO::getUsername, Users::setUsername).addMapping(UserDTO::getEmail, Users::setEmail)
		.addMapping(UserDTO::getRole, Users::setRole)
		.addMapping(UserDTO::getProfileImage, Users::setProfileImage)
		.addMapping(UserDTO::getIsActive, Users::setIsActive)
		.addMapping(UserDTO::getCreatedAt, Users::setCreatedAt)
		.addMappings(mapping -> mapping.skip(Users::setPassword));
    }

    private void configureQuizMapping(ModelMapper mapper) {
	// Quizzes -> QuizDTO
	mapper.createTypeMap(Quizzes.class, QuizDTO.class).addMapping(Quizzes::getQuizzId, QuizDTO::setQuizzId)
		.addMapping(Quizzes::getTitle, QuizDTO::setTitle)
		.addMapping(Quizzes::getDescription, QuizDTO::setDescription)
		.addMapping(Quizzes::getTimeLimit, QuizDTO::setTimeLimit)
		.addMapping(Quizzes::getTotalScore, QuizDTO::setTotalScore)
		.addMapping(Quizzes::getStatus, QuizDTO::setStatus)
		.addMapping(src -> src.getCategories() != null ? src.getCategories().getCategoryId() : null,
			QuizDTO::setCategoryId)
		.addMappings(mapperExpression -> mapperExpression.using(ctx -> {
		    List<Questions> questions = (List<Questions>) ctx.getSource();
		    if (questions == null) {
			return null;
		    }
		    return mapper.map(questions, new TypeToken<List<QuestionDTO>>() {
		    }.getType());
		}).map(Quizzes::getQuestionses, QuizDTO::setQuestions));

	// Questions -> QuestionDTO
	mapper.createTypeMap(Questions.class, QuestionDTO.class)
		.addMapping(Questions::getQuestionId, QuestionDTO::setQuestionId).addMapping(src -> {
		    Quizzes quizzes = src.getQuizzes();
		    return quizzes != null ? quizzes.getQuizzId() : null;
		}, QuestionDTO::setQuizzId).addMapping(Questions::getQuestionText, QuestionDTO::setQuestionText)
		.addMapping(Questions::getQuestionType, QuestionDTO::setQuestionType)
		.addMapping(Questions::getScore, QuestionDTO::setScore)
		.addMapping(Questions::getOrderIndex, QuestionDTO::setOrderIndex)
		.addMapping(Questions::getCreatedAt, QuestionDTO::setCreatedAt)
		.addMapping(Questions::getDeletedAt, QuestionDTO::setDeletedAt)
		.addMappings(mapperExpression -> mapperExpression.using(ctx -> {
		    List<Answers> answers = (List<Answers>) ctx.getSource();
		    if (answers == null) {
			return null;
		    }
		    return mapper.map(answers, new TypeToken<List<AnswerDTO>>() {
		    }.getType());
		}).map(Questions::getAnswerses, QuestionDTO::setAnswers));

	// Answers -> AnswerDTO
	mapper.createTypeMap(Answers.class, AnswerDTO.class).addMapping(Answers::getAnswerId, AnswerDTO::setAnswerId)
		.addMapping(src -> {
		    Questions question = src.getQuestions();
		    return question != null ? question.getQuestionId() : null;
		}, AnswerDTO::setQuestionId).addMapping(Answers::getAnswerText, AnswerDTO::setAnswerText)
		.addMapping(Answers::getIsCorrect, AnswerDTO::setIsCorrect)
		.addMapping(Answers::getOrderIndex, AnswerDTO::setOrderIndex)
		.addMapping(Answers::getCreatedAt, AnswerDTO::setCreatedAt)
		.addMapping(Answers::getDeletedAt, AnswerDTO::setDeletedAt);
    }
}