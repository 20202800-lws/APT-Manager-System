package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class BoardController {

	@GetMapping("/board/free_list") 
		public String freeList() {
			return "board/free_list"; // JSP 파일 이름 반환 }
		}
	}

