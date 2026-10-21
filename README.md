# 연운 비결 재료 계산기

연운(Where Winds Meet) 비결 육성에 드는 오금철·돌파 재료, 비결 지원 상자, 활·각지 제작 재료를 계산하는 팬 사이트예요.

- 사이트: https://ttemgp.github.io/wwm-mystic/
- 입력한 값은 브라우저(localStorage)에 저장되고, 로그인하면 계정에도 저장돼 다른 기기에서 이어서 볼 수 있어요.

## 로그인 저장(Supabase)

1. Supabase 프로젝트를 만들고 SQL Editor에서 `supabase/schema.sql`을 실행해요.
2. Authentication > URL Configuration의 Site URL과 Redirect URLs에 `https://ttemgp.github.io/wwm-mystic/`만 넣어요.
3. Authentication > Providers에서 쓸 로그인(구글·카카오)을 켜고, Email과 익명 로그인은 꺼요.
4. `index.html`의 `SB_URL`, `SB_KEY`에 Project URL과 공개 키(anon / publishable)를 넣어요. service_role 키는 절대 넣지 않아요.

각 사람은 자기 행만 읽고 쓸 수 있어요(행 단위 보안).
- 게임 데이터의 권리는 NetEase에 있어요.
