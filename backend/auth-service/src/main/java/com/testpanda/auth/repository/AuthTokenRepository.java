package com.testpanda.auth.repository;

import com.testpanda.auth.entity.AuthToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * AuthToken Repository
 * Refresh Token 데이터 접근 인터페이스
 */
@Repository
public interface AuthTokenRepository extends JpaRepository<AuthToken, Long> {

    /**
     * Refresh Token으로 조회
     * @param refreshToken Refresh Token 문자열
     * @return AuthToken Optional
     */
    Optional<AuthToken> findByRefreshToken(String refreshToken);

    /**
     * 사용자 ID로 모든 토큰 삭제 (로그아웃 시)
     * @param userId 사용자 ID
     */
    void deleteByUserId(Long userId);

    /**
     * 사용자 ID로 토큰 조회
     * @param userId 사용자 ID
     * @return AuthToken Optional
     */
    Optional<AuthToken> findByUserId(Long userId);
}
