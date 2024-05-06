// next.config.mjs
import path from 'path'

// __dirname の代わりにディレクトリパスを取得
const __dirname = path.dirname(new URL(import.meta.url).pathname)

const nextConfig = {
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      '@': path.resolve(__dirname, 'src'), // パスを 'src' に修正
    }

    return config
  },
}

export default nextConfig
