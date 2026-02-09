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

/* ==================================================
   [수정] 게시판 통합 및 업그레이드
   - PARENT_BOARD 삭제 (BOARD로 통합)
   - BOARD에 is_secret 추가 (비밀글 기능)
   ================================================== */

-- 1. 기존 테이블 정리
DROP TABLE IF EXISTS PARENT_BOARD; -- 이제 필요 없음!
DROP TABLE IF EXISTS COMMENT;      -- 다시 만들기 위해 삭제
DROP TABLE IF EXISTS BOARD;        -- 다시 만들기 위해 삭제

-- 2. 통합 게시판 (BOARD) 생성
-- category 컬럼으로 'GENERAL'(자유), 'PARENT'(부모님), 'MARKET'(장터) 등 구분
CREATE TABLE BOARD (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글번호',
    user_id VARCHAR(50) COMMENT '작성자',
    category VARCHAR(20) DEFAULT 'GENERAL' COMMENT '카테고리(GENERAL, PARENT)',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT COMMENT '내용',
    is_anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부(0:실명, 1:익명)',
    is_secret CHAR(1) DEFAULT 'N' COMMENT '비밀글(Y/N) - ★추가됨',
    views INT DEFAULT 0 COMMENT '조회수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 3. 댓글 (COMMENT) 생성
-- 이제 BOARD 하나만 바라보므로 모든 카테고리 글에 댓글 가능!
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

/* ==========================================================
   [1단계] 단순 컬럼명 변경 (ALTER)
   - is_ 접두사 제거 및 타입 변경 (CHAR -> TINYINT)
   ========================================================== */

-- 1. 사용자 (USERS) : is_approved -> approval_status
ALTER TABLE USERS 
CHANGE COLUMN is_approved approval_status TINYINT(1) DEFAULT 0 COMMENT '승인여부(0:대기,1:승인)';

-- 2. 시설 (FACILITY) : is_use -> available
ALTER TABLE FACILITY 
CHANGE COLUMN is_use available TINYINT(1) DEFAULT 1 COMMENT '운영여부(0:중지,1:운영)';

-- 3. 민원 (COMPLAINT) : is_secret -> secret
ALTER TABLE COMPLAINT 
CHANGE COLUMN is_secret secret TINYINT(1) DEFAULT 1 COMMENT '비밀글(0:공개,1:비밀)';

-- 4. 알림 (NOTIFICATIONS) : is_read -> read_state
ALTER TABLE NOTIFICATIONS 
CHANGE COLUMN is_read read_state TINYINT(1) DEFAULT 0 COMMENT '읽음여부(0:안읽음,1:읽음)';


/* ==========================================================
   [2단계] 구조가 많이 바뀌는 테이블 (DROP & CREATE)
   - 관리비, 게시판, 댓글 등 구조 변경이 큰 테이블은 재생성
   ========================================================== */

-- 외래키 제약 때문에 자식 테이블부터 삭제합니다.
DROP TABLE IF EXISTS FEE_LOG;       -- 관리비 로그 삭제
DROP TABLE IF EXISTS FEE_DETAIL;    -- 관리비 상세 삭제 (혹시 있다면)
DROP TABLE IF EXISTS MANAGE_FEE;    -- 관리비 삭제

DROP TABLE IF EXISTS COMMENT;       -- 댓글 삭제
DROP TABLE IF EXISTS BOARD;         -- 게시판 삭제
DROP TABLE IF EXISTS PARENT_BOARD;  -- 구 버전 테이블 삭제


-- ----------------------------------------------------------
-- 1. 관리비 (MANAGE_FEE) : is_paid -> payment_status 변경
-- ----------------------------------------------------------
CREATE TABLE MANAGE_FEE (
    fee_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '관리비번호',
    dong VARCHAR(20) COMMENT '동',
    ho VARCHAR(20) COMMENT '호',
    use_year INT COMMENT '년',
    use_month INT COMMENT '월',
    total_cost INT COMMENT '총금액',
    payment_status TINYINT(1) DEFAULT 0 COMMENT '납부여부(0:미납, 1:완납)'
);

-- [부활] 2. 관리비 상세 (FEE_DETAIL) : 항목별 관리
CREATE TABLE FEE_DETAIL (
    detail_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '상세번호',
    fee_id BIGINT NOT NULL COMMENT '관리비번호',
    item_name VARCHAR(50) NOT NULL COMMENT '항목명(전기,수도,일반관리비)',
    amount INT NOT NULL COMMENT '금액',
    FOREIGN KEY (fee_id) REFERENCES MANAGE_FEE(fee_id) ON DELETE CASCADE
);

-- 3. 관리비 로그 (FEE_LOG) : 다시 생성
CREATE TABLE FEE_LOG (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '로그번호',
    fee_id BIGINT COMMENT '관리비번호',
    admin_id VARCHAR(50) COMMENT '작업자',
    action_type VARCHAR(20) COMMENT '유형',
    change_desc TEXT COMMENT '내용',
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '일시',
    FOREIGN KEY (fee_id) REFERENCES MANAGE_FEE(fee_id) ON DELETE CASCADE
);


-- ----------------------------------------------------------
-- 4. 통합 게시판 (BOARD) : 좋아요 추가, 비밀글 삭제, is_ 제거
-- ----------------------------------------------------------
CREATE TABLE BOARD (
    board_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글번호',
    user_id VARCHAR(50) COMMENT '작성자',
    category VARCHAR(20) DEFAULT 'FREE' COMMENT '구분(FREE, ANON)',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT COMMENT '내용',
    anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부(0:실명, 1:익명)',
    views INT DEFAULT 0 COMMENT '조회수',
    like_count INT DEFAULT 0 COMMENT '좋아요수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL
);

-- 5. 댓글 (COMMENT) : 대댓글(parent_id, depth) 추가
CREATE TABLE COMMENT (
    reply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글번호',
    board_id BIGINT NOT NULL COMMENT '게시글ID',
    user_id VARCHAR(50) COMMENT '작성자',
    content TEXT COMMENT '내용',
    anonymous TINYINT(1) DEFAULT 0 COMMENT '익명여부',
    
    -- ★ 대댓글을 위한 핵심 컬럼
    parent_id BIGINT DEFAULT NULL COMMENT '부모댓글ID(NULL이면 최상위)',
    depth INT DEFAULT 0 COMMENT '계층(0:댓글, 1:대댓글)',
    
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (board_id) REFERENCES BOARD(board_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES COMMENT(reply_id) ON DELETE CASCADE
);


/* ==========================================================
   [3단계] 신규 추가 테이블 (CREATE)
   - 학부모 의견(피드), 학부모 의견 댓글
   ========================================================== */

-- 1. 학부모 의견 (PARENT_OPINION) : 이미지 제거된 피드형
CREATE TABLE PARENT_OPINION (
    opinion_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '의견번호',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자',
    content TEXT NOT NULL COMMENT '내용(텍스트)',
    like_count INT DEFAULT 0 COMMENT '좋아요수',
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);

-- 2. 학부모 의견 댓글 (PARENT_REPLY) : 대댓글 포함
CREATE TABLE PARENT_REPLY (
    reply_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글번호',
    opinion_id BIGINT NOT NULL COMMENT '의견번호',
    user_id VARCHAR(50) NOT NULL COMMENT '작성자',
    content VARCHAR(500) NOT NULL COMMENT '내용',
    
    -- ★ 대댓글 구조
    parent_id BIGINT DEFAULT NULL COMMENT '부모댓글ID',
    depth INT DEFAULT 0 COMMENT '계층(0:댓글, 1:대댓글)',
    
    reg_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    FOREIGN KEY (opinion_id) REFERENCES PARENT_OPINION(opinion_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES PARENT_REPLY(reply_id) ON DELETE CASCADE
);

commit