package com.testpanda.auth.repository;

import com.testpanda.auth.entity.Provider;
import com.testpanda.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * User Repository
 * 사용자 데이터 접근 인터페이스
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * 이메일로 사용자 조회
     * @param email 이메일
     * @return 사용자 Optional
     */
    Optional<User> findByEmail(String email);

    /**
     * 이메일 존재 여부 확인
     * @param email 이메일
     * @return 존재 여부
     */
    boolean existsByEmail(String email);

    /**
     * 소셜 로그인 제공자와 ID로 사용자 조회
     * @param provider 제공자 (GOOGLE, NAVER)
     * @param providerId 제공자 ID
     * @return 사용자 Optional
     */
    Optional<User> findByProviderAndProviderId(Provider provider, String providerId);
}
