import { Box } from '@chakra-ui/react'
import Link from 'next/link'

import { frontPaths } from '@/config/settings'

export default function Home() {
  return (
    <>
      <Box mx="auto" mt="10" width="100%" maxWidth="500px">
        <p>このページは管理画面です</p>
        <p>サーバーは fastapi、フロントは next で管理画面アプリを作ってみました</p>
        <p>
          管理画面はどんなプロジェクトでも使用すると思うので何なにかプロジェクトを作る際にはこのリポジトリを参考にしてみてください
        </p>
        <p>サンプルのため最低限の機能になります</p>
        <p>
          <a href="https://github.com/campbel2525/project-sample" target="_blank">
            詳しくはこちら
          </a>
        </p>
      </Box>
      <Box mx="auto" mt="10" width="100%" maxWidth="500px">
        <p>This page is a user screen</p>
        <p>
          I created a management screen app using fastapi for the server and next for
          the front.
        </p>
        <p>
          I think user management will be used in any project, so please refer to this
          repository when creating a project.
        </p>
        <p>Since it is a sample, it will have the minimum functionality.</p>
        <p>
          <a href="https://github.com/campbel2525/project-sample" target="_blank">
            Click here for details
          </a>
        </p>
      </Box>

      <Box mx="auto" mt="10" width="100%" maxWidth="500px">
        <div>
          <Link href={frontPaths.login} style={{ textDecoration: 'underline' }}>
            login
          </Link>
        </div>
        <div>
          <Link href={frontPaths.users} style={{ textDecoration: 'underline' }}>
            user index(required login)
          </Link>
        </div>
      </Box>
    </>
  )
}
