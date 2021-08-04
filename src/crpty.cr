module CrPty
  extend self

  VERSION = "0.1.0"

  @[Link(ldflags: "#{__DIR__}/constants.o")]
  lib LibConstants
    $ioctl_TIOCGWINSZ : LibC::ULong
  end

  lib C
    fun ioctl(fd : LibC::Int, request : LibC::Int, ...) : LibC::Int
  end

  @[Link("util")]
  lib LibUtil
    # glibc bits/ioctl-types.h
    struct Winsize
      ws_row : LibC::UShort
      ws_col : LibC::UShort
      ws_xpixel : LibC::UShort
      ws_ypixel : LibC::UShort
    end

    # glibc login/pty.h
    fun forkpty(amaster : LibC::Int*, name : LibC::Char*, termp : LibC::Termios*, winsize : Winsize*) : LibC::Int
  end

  class PtyResult
    getter pid : LibC::Int
    getter master_fd : LibC::Int

    def initialize(@pid : LibC::Int, @master_fd : LibC::Int)
    end
  end

  def fork_pty : PtyResult
    LibC.tcgetattr(STDIN.fd, out term)
    winsize = uninitialized LibUtil::Winsize
    C.ioctl(STDIN.fd, LibConstants.ioctl_TIOCGWINSZ, pointerof(winsize))
    pid = LibUtil.forkpty(out amaster, nil, pointerof(term), pointerof(winsize))

    PtyResult.new pid: pid, master_fd: amaster
  end
end

