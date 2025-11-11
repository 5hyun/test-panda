package com.testpanda.auth.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * 이메일 인증 엔티티
 * 회원가입 시 발송한 이메일 인증 토큰을 저장합니다.
 */
@Entity
@Table(name = "email_verifications")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmailVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * 사용자 ID (외래키)
     */
    @Column(name = "user_id", nullable = false)
    private Long userId;

    /**
     * 인증 토큰
     * - UUID 형식의 랜덤 문자열
     */
    @Column(nullable = false, unique = true)
    private String token;

    /**
     * 토큰 만료 일시
     * - 일반적으로 24시간
     */
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    /**
     * 인증 완료 여부
     */
    @Column(nullable = false)
    private Boolean verified = false;

    /**
     * 생성 일시
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
