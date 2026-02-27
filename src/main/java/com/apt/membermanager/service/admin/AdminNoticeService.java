package com.apt.membermanager.service.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.apt.membermanager.beans.BoardListBean;
import com.apt.membermanager.beans.NoticeListBean;
import com.apt.membermanager.dto.NoticeCreateDTO;
import com.apt.membermanager.entity.Board;
import com.apt.membermanager.entity.Notice;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.repository.NoticeRepository;
import com.apt.membermanager.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminNoticeService {

	private final NoticeRepository noticeRepository;
	private final UserRepository userRepository;
	
	@Transactional
	public Long createPost(NoticeCreateDTO DTO,String loginMemberId) {
		User user = userRepository.findByUserId(loginMemberId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
		Notice notice = Notice.builder()
							.title(DTO.getTitle())
							.content(DTO.getContent())
							.writer(user)
							.views(0)
							.build();
		return noticeRepository.save(notice).getNoticeId();
	}

	public Page<NoticeListBean> searchByNoticePaging(String loginId, String keyword,Pageable pageable) {
		// TODO Auto-generated method stub
		String searchKeyword = (keyword == null || keyword
    			.trim().isEmpty()) ? "" :keyword.trim();
		
		Page<Notice> entitiesPage = noticeRepository.findByTitleContaining(searchKeyword,pageable);
    	
    	List<NoticeListBean> list = entitiesPage.getContent().stream().map(entity->{
    		
    		return new NoticeListBean(entity,loginId);
    	}).collect(Collectors.toList());
    	
    	return new PageImpl<>(list,pageable,entitiesPage.getTotalElements());
    	
	}
	public Map<String,Long> getNoticeStatus(){
		Map<String, Long> status = new HashMap<>();
		status.put("total", noticeRepository.count());
		
		return status;
	}
	
}
