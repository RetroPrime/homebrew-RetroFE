class Retrofe < Formula
  desc "Simple robust frontend designed for MAME cabinets or game centers"
  homepage "http://retrofe.nl"
  url "https://bitbucket.org/phulshof/retrofe", :using => :hg, :branch => "default", :revision => "iee0a1614e73810e16b7a2184c30c38e614c7a3bb"
  version "0.7.20"
  head "https://bitbucket.org/RetroPrime/retrofe", :using => :hg

  depends_on "cmake" => :build
  depends_on "gst-plugins-bad"
  depends_on "sdl2_mixer"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"
  depends_on "sqlite"
  depends_on "dos2unix"

  def install
    ENV.deparallelize
    system "cmake", "RetroFE/Source", "-BRetroFE/Build", "-DVERSION_MAJOR=0", "-DVERSION_MINOR=0", "-DVERSION_BUILD=0"
    system "cmake", "--build", "RetroFE/Build"
    system "python", "Scripts/Package.py", "--os=mac", "--build=full"

    prefix.install "LICENSE.txt", "README.md", Dir["Artifacts/mac/RetroFE/*"]
    bin.mkdir
    bin.install_symlink prefix/"retrofe"
  end

  def caveats
    <<-EOS.undent
      RetroFE will be setup in #{opt_prefix} see http://retrofe.nl for more info.
      RetroFE depends on a backend such as RetroArch to load various emulator cores.
      Run `brew cask install retroarch` to install RetroArch in your Applications folder.
      Comands `retrofe -help`. To run as an Application ensure app bundle is symlinked.
    EOS
  end

  test do
    system "#{bin}/Artifacts/linux/RetroFE/retrofe", "--version"
  end
end
