package com.apt.membermanager.controller;

import com.apt.membermanager.entity.*;
import com.apt.membermanager.service.DaycareService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/daycare")
@RequiredArgsConstructor
public class DaycareController {

    private final DaycareService daycareService;

    @GetMapping("/notice")
    public String noticeList(Model model) { 
        model.addAttribute("notices", daycareService.getAllNotices());
        return "daycare/daycare_notice_list";
    }
    
    @GetMapping("/notice/write")
    public String noticeWrite() { 
        return "daycare/daycare_notice_write";
    }

    @PostMapping("/notice/write")
    public String noticeWriteSubmit(DaycareNotice notice, 
                                    @RequestParam(value = "isTop", defaultValue = "false") Boolean isTop,
                                    @RequestParam("uploadFiles") List<MultipartFile> files, 
                                    HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        notice.setWriter(loginMember);
        notice.setIsTop(isTop);
        daycareService.saveNoticeWithFiles(notice, files);
        return "redirect:/daycare/notice";
    }

    @GetMapping("/notice/view")
    public String noticeView(@RequestParam("id") Long id, Model model) { 
        model.addAttribute("post", daycareService.getNoticeDetail(id));
        List<Attachment> files = daycareService.getAttachments("DAYCARE_NOTICE", id);
        model.addAttribute("attachments", files);
        return "daycare/daycare_notice_view";
    }

    @GetMapping("/notice/edit")
    public String noticeEditForm(@RequestParam("id") Long id, Model model) {
        model.addAttribute("post", daycareService.getNoticeDetail(id));
        return "daycare/daycare_notice_edit";
    }

    @PostMapping("/notice/edit")
    public String noticeEditSubmit(@RequestParam("noticeId") Long noticeId,
                                   @RequestParam("title") String title,
                                   @RequestParam("content") String content,
                                   @RequestParam(value = "isTop", defaultValue = "false") Boolean isTop,
                                   @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> files,
                                   HttpSession session) {
        
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.updateNotice(noticeId, title, content, isTop, files, loginMember);
        
        return "redirect:/daycare/notice/view?id=" + noticeId;
    }

    @GetMapping("/gallery")
    public String galleryList(Model model) { 
        model.addAttribute("galleries", daycareService.getAllGalleries());
        return "daycare/daycare_gallery_list";
    }

    @GetMapping("/gallery/write")
    public String galleryWrite() { 
        return "daycare/daycare_gallery_write";
    }

    @PostMapping("/gallery/write")
    public String galleryWriteSubmit(DaycareGallery gallery, 
                                     @RequestParam("uploadFiles") List<MultipartFile> files, 
                                     HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        gallery.setWriter(loginMember);
        daycareService.saveGalleryWithFiles(gallery, files);
        return "redirect:/daycare/gallery";
    }

    @GetMapping("/gallery/view")
    public String galleryView(@RequestParam("id") Long id, Model model) { 
        model.addAttribute("post", daycareService.getGalleryDetail(id));
        List<Attachment> images = daycareService.getAttachments("DAYCARE_GALLERY", id);
        model.addAttribute("images", images);
        return "daycare/daycare_gallery_view";
    }

    // ==========================================
    // ★ [신규 추가] 갤러리 댓글 등록 및 삭제 기능
    // ==========================================
    @PostMapping("/gallery/comment")
    public String addGalleryComment(@RequestParam("postId") Long postId,
                                    @RequestParam("content") String content,
                                    HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.saveGalleryComment(postId, content, loginMember);
        return "redirect:/daycare/gallery/view?id=" + postId;
    }

    @PostMapping("/gallery/comment/delete")
    public String deleteGalleryComment(@RequestParam("commentId") Long commentId,
                                       @RequestParam("postId") Long postId,
                                       HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.deleteGalleryComment(commentId, loginMember);
        return "redirect:/daycare/gallery/view?id=" + postId;
    }
    // ==========================================

    @GetMapping("/parent")
    public String parentList(Model model) { 
        model.addAttribute("opinions", daycareService.getAllParentOpinions());
        return "daycare/daycare_parent_list";
    }

    @PostMapping("/parent/write")
    public String parentWriteSubmit(@RequestParam("content") String content, HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.saveParentOpinion(content, loginMember);
        return "redirect:/daycare/parent";
    }

    @PostMapping("/parent/update")
    public String parentUpdate(@RequestParam("id") Long opinionId, 
                               @RequestParam("content") String content, 
                               HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.updateParentOpinion(opinionId, content, loginMember);
        return "redirect:/daycare/parent";
    }
    
    @PostMapping("/parent/delete")
    public String parentDelete(@RequestParam("id") Long opinionId, HttpSession session) {
        User loginMember = (User) session.getAttribute("loginMember");
        daycareService.deleteOpinionIfOwner(opinionId, loginMember);
        return "redirect:/daycare/parent";
    }
}