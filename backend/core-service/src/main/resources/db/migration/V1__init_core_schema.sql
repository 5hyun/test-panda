-- Core Service 초기 스키마
-- groups, group_members, exams, exam_groups, questions, submissions, answers, custom_columns, custom_scores 테이블 생성

-- 그룹 테이블
CREATE TABLE groups (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id BIGINT NOT NULL,
    invite_code VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_groups_owner_id ON groups(owner_id);
CREATE INDEX idx_groups_invite_code ON groups(invite_code);

-- 그룹 멤버 테이블
CREATE TABLE group_members (
    id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'MEMBER',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
    UNIQUE (group_id, user_id)
);
CREATE INDEX idx_group_members_group_id ON group_members(group_id);
CREATE INDEX idx_group_members_user_id ON group_members(user_id);

-- 시험지 테이블
CREATE TABLE exams (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id BIGINT NOT NULL,
    time_limit INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    is_published BOOLEAN DEFAULT FALSE,
    allow_review BOOLEAN DEFAULT TRUE,
    shuffle_questions BOOLEAN DEFAULT FALSE,
    shuffle_choices BOOLEAN DEFAULT FALSE,
    show_score_immediately BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_exams_owner_id ON exams(owner_id);
CREATE INDEX idx_exams_is_published ON exams(is_published);

-- 시험지-그룹 매핑 테이블 (다대다)
CREATE TABLE exam_groups (
    id BIGSERIAL PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
    UNIQUE (exam_id, group_id)
);
CREATE INDEX idx_exam_groups_exam_id ON exam_groups(exam_id);
CREATE INDEX idx_exam_groups_group_id ON exam_groups(group_id);

-- 문제 테이블 (JSONB 사용)
CREATE TABLE questions (
    id BIGSERIAL PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    type VARCHAR(50) NOT NULL,
    order_num INT NOT NULL,
    content TEXT NOT NULL,
    media_urls JSONB,
    points NUMERIC(10, 2) NOT NULL DEFAULT 0,
    answer_data JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);
CREATE INDEX idx_questions_exam_id ON questions(exam_id);
CREATE INDEX idx_questions_type ON questions(type);

-- 제출 테이블
CREATE TABLE submissions (
    id BIGSERIAL PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    score NUMERIC(10, 2),
    max_score NUMERIC(10, 2),
    status VARCHAR(50) NOT NULL DEFAULT 'IN_PROGRESS',
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submitted_at TIMESTAMP,
    graded_at TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
    UNIQUE (exam_id, user_id)
);
CREATE INDEX idx_submissions_exam_id ON submissions(exam_id);
CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_status ON submissions(status);

-- 답안 테이블 (JSONB 사용)
CREATE TABLE answers (
    id BIGSERIAL PRIMARY KEY,
    submission_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    answer_data JSONB NOT NULL,
    score NUMERIC(10, 2),
    is_correct BOOLEAN,
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE (submission_id, question_id)
);
CREATE INDEX idx_answers_submission_id ON answers(submission_id);
CREATE INDEX idx_answers_question_id ON answers(question_id);

-- 커스텀 컬럼 테이블 (성적표 커스터마이징)
CREATE TABLE custom_columns (
    id BIGSERIAL PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    column_name VARCHAR(255) NOT NULL,
    column_type VARCHAR(50) NOT NULL,
    display_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);
CREATE INDEX idx_custom_columns_exam_id ON custom_columns(exam_id);

-- 커스텀 점수 테이블
CREATE TABLE custom_scores (
    id BIGSERIAL PRIMARY KEY,
    submission_id BIGINT NOT NULL,
    column_id BIGINT NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (column_id) REFERENCES custom_columns(id) ON DELETE CASCADE,
    UNIQUE (submission_id, column_id)
);
CREATE INDEX idx_custom_scores_submission_id ON custom_scores(submission_id);
CREATE INDEX idx_custom_scores_column_id ON custom_scores(column_id);
