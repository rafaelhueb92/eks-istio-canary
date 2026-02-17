import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // produce a standalone server build to simplify the production image
  output: "standalone",
};

export default nextConfig;
