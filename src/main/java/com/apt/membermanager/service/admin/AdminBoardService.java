package com.apt.membermanager.service.admin;

import org.springframework.stereotype.Service;

import com.apt.membermanager.repository.BoardRepository;
import com.apt.membermanager.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminBoardService {
	
	private final BoardRepository boardRepository;
}
