package com.testpanda.auth.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * 사용자 엔티티
 * Auth Service의 핵심 엔티티로, 사용자 정보를 관리합니다.
 */
@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * 이메일 (로그인 ID)
     * - 필수 입력
     * - 중복 불가 (UNIQUE 제약조건)
     */
    @Column(nullable = false, unique = true)
    private String email;

    /**
     * 비밀번호 (BCrypt 해시)
     * - 소셜 로그인 사용자는 null 가능
     */
    @Column
    private String password;

    /**
     * 사용자 이름
     */
    @Column(nullable = false, length = 100)
    private String name;

    /**
     * 사용자 역할 (선생님/학생)
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    /**
     * 이메일 인증 여부
     */
    @Column(name = "email_verified", nullable = false)
    private Boolean emailVerified = false;

    /**
     * 소셜 로그인 제공자
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Provider provider = Provider.LOCAL;

    /**
     * 소셜 로그인 제공자 ID
     * - 구글/네이버에서 제공하는 고유 ID
     */
    @Column(name = "provider_id")
    private String providerId;

    /**
     * 생성 일시
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /**
     * 수정 일시
     */
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
