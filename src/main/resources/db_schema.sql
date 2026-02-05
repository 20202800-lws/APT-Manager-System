-- 1. 데이터베이스(스키마) 만들기
CREATE DATABASE IF NOT EXISTS apt_management;

-- 2. "지금부터 이 데이터베이스를 쓰겠다"고 선언하기 (중요!)
USE apt_management;

-- (여기 밑에 아까 드린 CREATE TABLE 코드들이 쭉 이어지면 됩니다)

-- ==========================================
-- 1. 사용자 (USERS) - 모든 테이블의 부모
-- ==========================================
CREATE TABLE USERS (
    user_id VARCHAR(50) PRIMARY KEY COMMENT '아이디',
    user_pw VARCHAR(255) NOT NULL COMMENT '비밀번호',
    user_name VARCHAR(50) NOT NULL COMMENT '이름',
    dong VARCHAR(20) COMMENT '동',
    ho VARCHAR(20) COMMENT '호수',
    user_role VARCHAR(20) DEFAULT 'USER' COMMENT '권한',
    phone VARCHAR(20) COMMENT '전화번호',
    email VARCHAR(100) COMMENT '이메일',
    birth_date VARCHAR(20) COMMENT '생년월일',
    gender_digit CHAR(1) COMMENT '성별코드',
    is_approved CHAR(1) DEFAULT 'N' COMMENT '승인여부',
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    withdrawal_date DATETIME COMMENT '탈퇴일시'
);

-- ==========================================
-- 2. 시설 정보 (FACILITY) - 예약의 부모 (ERD엔 없었지만 필수!)
-- ==========================================
CREATE TABLE FACILITY (
    fac_id VARCHAR(20) PRIMARY KEY COMMENT '시설ID',
    fac_name VARCHAR(50) COMMENT '시설명',
    unit_price INT COMMENT '이용료',
    capacity INT COMMENT '수용인원',
    fac_location VARCHAR(100) COMMENT '위치',
    is_use CHAR(1) DEFAULT 'Y' COMMENT '운영여부'
);

-- ==========================================
-- 3. 프로그램 (PROGRAM) - 신청의 부모
-- ==========================================
CREATE TABLE PROGRAM (
    prog_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '강습번호',
    prog_name VARCHAR(100) COMMENT '강습명',
    instructor VARCHAR(50) COMMENT '강사',
    target_day VARCHAR(50) COMMENT '요일',
    fee INT COMMENT '수강료',
    description TEXT COMMENT '설명',
    capacity INT DEFAULT 0 COMMENT '정원'
);

-- ==========================================
-- 4. 관리비 (MANAGE_FEE) - 로그의 부모
-- ==========================================
CREATE TABLE MANAGE_FEE (
    fee_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '관리비번호',
    dong VARCHAR(20) COMMENT '동',
    ho VARCHAR(20) COMMENT '호',
    use_year INT COMMENT '년',
    use_month INT COMMENT '월',
    total_cost INT COMMENT '금액',
    is_paid CHAR(1) DEFAULT 'N' COMMENT '납부여부'
);

-- ==========================================
-- 5. 입주민 게시판 (BOARD)
-- ==========================================
CREATE TABLE BOARD (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글번호',
    user_id VARCHAR(50) COMMENT '작성자',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT COMMENT '내용',
    is_anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부',
    views INT DEFAULT 0 COMMENT '조회수',
    category VARCHAR(20) COMMENT '카테고리',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 6. 댓글 (COMMENT)
-- ==========================================
CREATE TABLE COMMENT (
    reply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글번호',
    board_id BIGINT NOT NULL COMMENT '게시글ID',
    user_id VARCHAR(50) COMMENT '작성자',
    content TEXT COMMENT '내용',
    is_anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (board_id) REFERENCES BOARD(board_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 7. 공지사항 (NOTICE)
-- ==========================================
CREATE TABLE NOTICE (
    notice_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '공지번호',
    writer_id VARCHAR(50) COMMENT '작성자',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    views INT DEFAULT 0 COMMENT '조회수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (writer_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 8. 민원 게시판 (COMPLAINT)
-- ==========================================
CREATE TABLE COMPLAINT (
    comp_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '민원번호',
    user_id VARCHAR(50) COMMENT '작성자',
    category VARCHAR(50) COMMENT '분류',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    reply TEXT COMMENT '관리자 답변',
    phone VARCHAR(20) COMMENT '비상연락처',
    comp_status VARCHAR(20) DEFAULT 'WAIT' COMMENT '상태',
    is_secret CHAR(1) DEFAULT 'N' COMMENT '비밀글',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    receipt_date DATETIME COMMENT '접수일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 9. 관리비 로그 (FEE_LOG)
-- ==========================================
CREATE TABLE FEE_LOG (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '로그번호',
    fee_id BIGINT COMMENT '관리비번호',
    admin_id VARCHAR(50) COMMENT '작업자',
    action_type VARCHAR(20) COMMENT '유형',
    change_desc TEXT COMMENT '내용',
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '일시',
    FOREIGN KEY (fee_id) REFERENCES MANAGE_FEE(fee_id) ON DELETE CASCADE
);

-- ==========================================
-- 10. 어린이집 알림장 (DAYCARE_NOTICE)
-- ==========================================
CREATE TABLE DAYCARE_NOTICE (
    notice_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '알림장번호',
    category VARCHAR(50) COMMENT '분류',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    writer_id VARCHAR(50) COMMENT '작성자',
    views INT DEFAULT 0 COMMENT '조회수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (writer_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 11. 부모님 게시판 (PARENT_BOARD)
-- ==========================================
CREATE TABLE PARENT_BOARD (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글번호',
    title VARCHAR(200) COMMENT '제목',
    content TEXT COMMENT '내용',
    writer_id VARCHAR(50) COMMENT '작성자',
    views INT DEFAULT 0 COMMENT '조회수',
    is_secret CHAR(1) DEFAULT 'N' COMMENT '비밀글',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (writer_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- ==========================================
-- 12. 차량 정보 (VEHICLE)
-- ==========================================
CREATE TABLE VEHICLE (
    car_number VARCHAR(20) PRIMARY KEY COMMENT '차량번호',
    user_id VARCHAR(50) COMMENT '소유주',
    phone VARCHAR(20) COMMENT '연락처',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- ==========================================
-- 13. 방문 차량 예약 (VISIT_VEHICLE)
-- ==========================================
CREATE TABLE VISIT_VEHICLE (
    visit_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '방문증번호',
    user_id VARCHAR(50) COMMENT '초대자',
    car_number VARCHAR(20) COMMENT '차량번호',
    visit_purpose VARCHAR(100) COMMENT '목적',
    visit_date DATE COMMENT '방문일',
    visit_status VARCHAR(20) COMMENT '상태',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- ==========================================
-- 14. 시설 예약 (FACILITY_RES)
-- ==========================================
CREATE TABLE FACILITY_RES (
    res_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '예약번호',
    user_id VARCHAR(50) COMMENT '예약자',
    fac_id VARCHAR(20) COMMENT '시설ID',
    res_date DATE COMMENT '예약날짜',
    start_time INT COMMENT '시작시간',
    end_time INT COMMENT '종료시간',
    people_count INT COMMENT '인원',
    total_price INT COMMENT '금액',
    res_status VARCHAR(20) COMMENT '상태',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL,
    FOREIGN KEY (fac_id) REFERENCES FACILITY(fac_id) ON DELETE SET NULL
);

-- ==========================================
-- 15. 프로그램 신청 (PROGRAM_APPLY)
-- ==========================================
CREATE TABLE PROGRAM_APPLY (
    apply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '신청번호',
    prog_id BIGINT COMMENT '강습번호',
    user_id VARCHAR(50) COMMENT '신청자',
    apply_status VARCHAR(20) COMMENT '상태',
    apply_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    FOREIGN KEY (prog_id) REFERENCES PROGRAM(prog_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- ==========================================
-- 16. 첨부파일 (ATTACHMENTS) - 공통
-- ==========================================
CREATE TABLE ATTACHMENTS (
    file_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '파일ID',
    ref_table VARCHAR(50) COMMENT '참조테이블명',
    ref_id BIGINT COMMENT '참조글번호',
    org_file_name VARCHAR(255) COMMENT '원본명',
    saved_file_name VARCHAR(255) COMMENT '저장명',
    file_path VARCHAR(500) COMMENT '경로',
    file_size BIGINT COMMENT '크기',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일'
);

-- ==========================================
-- 17. 알림 (NOTIFICATIONS)
-- ==========================================
CREATE TABLE NOTIFICATIONS (
    noti_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '알림ID',
    user_id VARCHAR(50) COMMENT '수신자',
    message VARCHAR(500) COMMENT '내용',
    is_read CHAR(1) DEFAULT 'N' COMMENT '읽음',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '발송일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

commit