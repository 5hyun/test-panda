package com.testpanda.auth.repository;

import com.testpanda.auth.entity.EmailVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * EmailVerification Repository
 * 이메일 인증 데이터 접근 인터페이스
 */
@Repository
public interface EmailVerificationRepository extends JpaRepository<EmailVerification, Long> {

    /**
     * 토큰으로 조회
     * @param token 인증 토큰
     * @return EmailVerification Optional
     */
    Optional<EmailVerification> findByToken(String token);

    /**
     * 사용자 ID로 조회 (최신 순)
     * @param userId 사용자 ID
     * @return EmailVerification Optional
     */
    Optional<EmailVerification> findFirstByUserIdOrderByCreatedAtDesc(Long userId);

    /**
     * 사용자 ID로 미인증 토큰 삭제
     * @param userId 사용자 ID
     */
    void deleteByUserIdAndVerifiedFalse(Long userId);
}
