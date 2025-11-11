package com.testpanda.auth.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * 인증 토큰 엔티티
 * Refresh Token을 저장하고 관리합니다.
 */
@Entity
@Table(name = "auth_tokens")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * 사용자 ID (외래키)
     */
    @Column(name = "user_id", nullable = false)
    private Long userId;

    /**
     * Refresh Token
     * - JWT 형식의 긴 문자열
     */
    @Column(name = "refresh_token", nullable = false, length = 500)
    private String refreshToken;

    /**
     * 토큰 만료 일시
     */
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    /**
     * 생성 일시
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
