# 🏢 APARTNERS 프론트엔드 화면 명세서

[💡 권한(Role) 정의 안내]
* ALL: 비회원 포함 누구나 접근 가능
* USER: 일반 입주민 (※ 기획 기준: 학부모, 어린이집 선생님 권한을 기본적으로 포함)
* TEACHER / PARENT: 어린이집 전용 특화 권한 (추후 세분화 적용 예정)
* ADMIN: 총괄 관리자 (모든 메뉴 접근 가능)

--------------------------------------------------

WEB-INF/jsp
│
├── 📄 home.jsp                   (PGM-COM-001)  [권한: ALL]
│
├── 📂 layout (공통 레이아웃)
│   ├── 📄 header_auth.jsp         (LAY-HDR-001)
│   ├── 📄 header_intro.jsp        (LAY-HDR-002)
│   ├── 📄 header_sub.jsp          (LAY-HDR-003)
│   ├── 📄 lnb.jsp                 (LAY-LNB-001)
│   ├── 📄 admin_sidebar.jsp       (LAY-ADM-001)
│   └── 📄 footer.jsp              (LAY-FTR-001)
│ 
├── 📂 member (로그인 관련) - [권한: ALL]
│   ├── 📄 login.jsp               (PGM-MEM-001)
│   ├── 📄 signup.jsp              (PGM-MEM-002)
│   └── 📄 find_account.jsp        (PGM-MEM-003)
│ 
├── 📂 mypage (마이페이지) - [권한: USER, ADMIN]
│   ├── 📄 info_view.jsp           (PGM-MYP-001)
│   ├── 📄 info_edit.jsp           (PGM-MYP-002)
│   ├── 📄 fee_view.jsp            (PGM-MYP-003)
│   ├── 📄 act_main.jsp            (PGM-MYP-004)
│   ├── 📄 act_posts.jsp           (PGM-MYP-005)
│   ├── 📄 act_reply.jsp           (PGM-MYP-006)
│   └── 📄 withdraw.jsp            (PGM-MYP-007)
│  
├── 📂 intro (아파트 소개) - [권한: ALL]
│   ├── 📄 layout.jsp              (PGM-INT-001)
│   ├── 📄 guide.jsp               (PGM-INT-002)
│   └── 📄 floor_plan.jsp          (PGM-INT-003)
│ 
├── 📂 board (게시판) - [권한: USER, ADMIN]
│   ├── 📄 free_list.jsp           (PGM-BRD-001)
│   ├── 📄 free_write.jsp          (PGM-BRD-002)
│   ├── 📄 free_view.jsp           (PGM-BRD-003)
│   ├── 📄 anon_list.jsp           (PGM-BRD-004)
│   ├── 📄 anon_write.jsp          (PGM-BRD-005)
│   ├── 📄 anon_view.jsp           (PGM-BRD-006)
│   ├── 📄 comp_list.jsp           (PGM-BRD-007)
│   ├── 📄 comp_write.jsp          (PGM-BRD-008)
│   ├── 📄 comp_view.jsp           (PGM-BRD-009)
│   └── 📄 report_pop.jsp          (PGM-BRD-010)
│ 
├── 📂 daycare (게시판 - 어린이집) - [권한: TEACHER, PARENT, ADMIN] ✨ (권한 세분화)
│   ├── 📄 notice_list.jsp         (PGM-KID-001)
│   ├── 📄 notice_view.jsp         (PGM-KID-002)
│   ├── 📄 gallery_list.jsp        (PGM-KID-003)
│   ├── 📄 gallery_view.jsp        (PGM-KID-004)
│   ├── 📄 parent_list.jsp         (PGM-KID-005)
│   ├── 📄 write_form.jsp          (PGM-KID-006)
│   └── 📄 parent_write.jsp        (PGM-KID-007)
│  
├── 📂 facility (커뮤니티 시설) - [권한: USER, ADMIN]
│   ├── 📄 info_class.jsp          (PGM-FAC-001)
│   ├── 📄 info_gym.jsp            (PGM-FAC-002)
│   ├── 📄 info_pool.jsp           (PGM-FAC-003)
│   ├── 📄 info_golf.jsp           (PGM-FAC-004)
│   └── 📄 info_guest.jsp          (PGM-FAC-005)
│ 
├── 📂 parking (주차 시설) - [권한: USER, ADMIN]
│   ├── 📄 my_car.jsp              (PGM-PAR-001)
│   └── 📄 visit_book.jsp          (PGM-PAR-002)
│ 
├── 📂 reservation (예약 및 관리) - [권한: USER, ADMIN]
│   ├── 📄 my_list.jsp             (PGM-RES-001)
│   ├── 📄 fac_book.jsp            (PGM-RES-002)
│   └── 📄 prog_book.jsp           (PGM-RES-003)
│ 
├── 📂 notice (공지사항) - [권한: USER, ADMIN] ✨ (입주민 전용으로 변경)
│   ├── 📄 notice_list.jsp         (PGM-NOT-001)
│   └── 📄 notice_detail.jsp       (PGM-NOT-002)
│ 
└── 📂 admin (관리자) - [권한: ADMIN]
    ├── 📄 main.jsp                (PGM-ADM-001)
    ├── 📄 member_list.jsp         (PGM-ADM-002)
    ├── 📄 fee_manage.jsp          (PGM-ADM-003)
    ├── 📄 fee_log.jsp             (PGM-ADM-003-1)
    ├── 📄 res_manage.jsp          (PGM-ADM-004)
    ├── 📄 notice_manage.jsp       (PGM-ADM-005)
    ├── 📄 board_manage.jsp        (PGM-ADM-006)
    ├── 📄 comp_manage.jsp         (PGM-ADM-007)
    ├── 📄 parking_manage.jsp      (PGM-ADM-008)
    └── 📄 report_manage.jsp       (PGM-ADM-009)