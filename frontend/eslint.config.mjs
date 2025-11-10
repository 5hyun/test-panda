import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  // Override default ignores of eslint-config-next.
  globalIgnores([
    // Default ignores of eslint-config-next:
    ".next/**",
    "out/**",
    "build/**",
    "next-env.d.ts",
  ]),
  // 커스텀 규칙 (프로젝트용)
  {
    rules: {
      // console.log는 경고 (개발 중에는 허용하되 배포 전 제거 권장)
      "no-console": ["warn", { allow: ["warn", "error", "info"] }],

      // 사용하지 않는 변수 경고
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_"
        }
      ],

      // any 타입 사용 경고 (불가피한 경우에만)
      "@typescript-eslint/no-explicit-any": "warn",

      // React hooks 의존성 배열 검사 (Next.js preset에 포함되어 있지만 명시)
      "react-hooks/exhaustive-deps": "warn",
    },
  },
]);

export default eslintConfig;
