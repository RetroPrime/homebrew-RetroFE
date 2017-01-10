class Retrofe < Formula
  desc "Simple robust frontend designed for MAME cabinets or game centers"
  homepage "http://retrofe.nl"
  url "https://bitbucket.org/phulshof/retrofe", :using => :hg, :branch => "default", :revision => "f31087ecd55455d9406813bf590576ced30fae84"
  version "0.7.20b1"
  skip_clean "Artifacts/mac/RetroFE"
  head "https://bitbucket.org/phulshof/retrofe", :using => :hg

  depends_on "cmake" => :build
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-good"
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

    prefix.install Dir.glob("*.txt"), Dir.glob("*.md"), "Artifacts/mac/RetroFE/retrofe", "Artifacts/mac/RetroFE/RetroFE.app"
    bin.mkdir
    bin.install_symlink prefix/"retrofe"

    unless File.directory?("/usr/local/var/RetroFE")
      var.install "Artifacts/mac/RetroFE"
    end

    prefix.install_symlink Dir.glob("/usr/local/var/RetroFE/*")
  end

  def caveats
    <<-EOS.undent
      RetroFE will be setup in #{opt_prefix} see http://retrofe.nl for more info.
      RetroFE depends on a backend such as RetroArch to load various emulator cores.
      Run `brew cask install retroarch` to install RetroArch in your Applications folder.
      Run `retrofe -help` for commands. To run as an Application ensure app bundle is symlinked.
    EOS
  end

  test do
    system "#{bin}/Artifacts/linux/RetroFE/retrofe", "--version"
  end
end
