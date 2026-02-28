package com.apt.membermanager.controller;

import com.apt.membermanager.dto.ComplaintWriteDto;
import com.apt.membermanager.entity.Complaint;
import com.apt.membermanager.entity.User;
import com.apt.membermanager.entity.Attachment;
import com.apt.membermanager.service.ComplaintService;
import com.apt.membermanager.repository.AttachmentRepository;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/board/comp")
@RequiredArgsConstructor
public class ComplaintController {

    private final ComplaintService complaintService;
    // ★ 우리가 완성한 첨부파일 레포지토리 사수!
    private final AttachmentRepository attachmentRepository;

    // 1. 민원 목록
    @GetMapping
    public String compList(@RequestParam(value = "keyword", required = false) String keyword,
                           @RequestParam(value = "page", defaultValue = "0") int page, Model model, Principal principal,
                           HttpSession session) {
        User loginUser = (User) session.getAttribute("loginMember");
        if (loginUser == null)
            return "redirect:/member/login";

        Pageable pageable = PageRequest.of(page, 10, Sort.by("compId").descending());
        Page<Complaint> paging = complaintService.searchComplaints(principal.getName(), loginUser.getUserRole(),
                keyword, pageable);

        model.addAttribute("paging", paging);
        model.addAttribute("keyword", keyword);
        return "board/comp_list";
    }

    // 2. 민원 작성 폼
    @GetMapping("/write")
    public String writeForm() {
        return "board/comp_write";
    }

    // 3. 민원 작성 처리 (사진 업로드 포함 완벽 연동!)
    @PostMapping("/write")
    public String writeAction(ComplaintWriteDto dto, Principal principal) {
        Long compId = complaintService.writeComplaint(principal.getName(), dto);
        return "redirect:/board/comp/view/" + compId;
    }

    // 4. 민원 상세 보기 (첨부파일 갤러리 + 프록시 에러 해결 적용)
    @GetMapping("/view/{id}")
    public String detail(@PathVariable("id") Long id, Model model, Principal principal, HttpSession session,
                         RedirectAttributes rttr) {
        User loginUser = (User) session.getAttribute("loginMember");
        if (loginUser == null)
            return "redirect:/member/login";

        try {
            Complaint complaint = complaintService.getComplaintDetail(id, principal.getName(), loginUser.getUserRole());
            List<Attachment> attachments = attachmentRepository.findByRefTableAndRefId("COMPLAINT", id);

            // ★ HibernateProxy 지연 로딩 에러 방어막
            String writerName = (complaint.getUser() != null) ? complaint.getUser().getRealName() : "알 수 없음";

            model.addAttribute("post", complaint);
            model.addAttribute("writerName", writerName);
            model.addAttribute("attachments", attachments);

            return "board/comp_view";
        } catch (SecurityException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/board/comp";
        }
    }

    // 5. 민원 삭제 처리 (404 에러 방어막)
    @PostMapping("/delete")
    public String deleteAction(@RequestParam("id") Long id, Principal principal, HttpSession session, RedirectAttributes rttr) {
        User loginUser = (User) session.getAttribute("loginMember");
        if (loginUser == null) return "redirect:/member/login";

        try {
            complaintService.deleteComplaint(id, principal.getName(), loginUser.getUserRole());
            rttr.addFlashAttribute("msg", "민원이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        }
        return "redirect:/board/comp";
    }
}