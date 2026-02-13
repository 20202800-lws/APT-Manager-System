package com.apt.membermanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

//구현 위해 임의로 만듬 - 다영
@Controller
public class IntroController {
	@GetMapping("/board/free_list") 
	public String freeList() {
		return "board/free_list"; // JSP 파일 이름 반환 }
	}
}
