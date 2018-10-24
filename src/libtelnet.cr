@[Link("telnet")]
lib LibTelnet
  type Telnet = Void
  type UserData = Void

  struct TelOpt
    telopt : Int16
    us     : UInt8
    them   : UInt8
  end

  enum Command : UInt8
    TELNET_IAC   = 255,
    TELNET_DONT  = 254,
    TELNET_DO    = 253,
    TELNET_WONT  = 252,
    TELNET_WILL  = 251,
    TELNET_SB    = 250,
    TELNET_GA    = 249,
    TELNET_EL    = 248,
    TELNET_EC    = 247,
    TELNET_AYT   = 246,
    TELNET_AO    = 245,
    TELNET_IP    = 244,
    TELNET_BREAK = 243,
    TELNET_DM    = 242,
    TELNET_NOP   = 241,
    TELNET_SE    = 240,
    TELNET_EOR   = 239,
    TELNET_ABORT = 238,
    TELNET_SUSP  = 237,
    TELNET_EOF   = 236
  end

  enum Option : UInt8
    TELNET_TELOPT_BINARY         =  0,
    TELNET_TELOPT_ECHO           =  1,
    TELNET_TELOPT_RCP            =  2,
    TELNET_TELOPT_SGA            =  3,
    TELNET_TELOPT_NAMS           =  4,
    TELNET_TELOPT_STATUS         =  5,
    TELNET_TELOPT_TM             =  6,
    TELNET_TELOPT_RCTE           =  7,
    TELNET_TELOPT_NAOL           =  8,
    TELNET_TELOPT_NAOP           =  9,
    TELNET_TELOPT_NAOCRD         = 10,
    TELNET_TELOPT_NAOHTS         = 11,
    TELNET_TELOPT_NAOHTD         = 12,
    TELNET_TELOPT_NAOFFD         = 13,
    TELNET_TELOPT_NAOVTS         = 14,
    TELNET_TELOPT_NAOVTD         = 15,
    TELNET_TELOPT_NAOLFD         = 16,
    TELNET_TELOPT_XASCII         = 17,
    TELNET_TELOPT_LOGOUT         = 18,
    TELNET_TELOPT_BM             = 19,
    TELNET_TELOPT_DET            = 20,
    TELNET_TELOPT_SUPDUP         = 21,
    TELNET_TELOPT_SUPDUPOUTPUT   = 22,
    TELNET_TELOPT_SNDLOC         = 23,
    TELNET_TELOPT_TTYPE          = 24,
    TELNET_TELOPT_EOR            = 25,
    TELNET_TELOPT_TUID           = 26,
    TELNET_TELOPT_OUTMRK         = 27,
    TELNET_TELOPT_TTYLOC         = 28,
    TELNET_TELOPT_3270REGIME     = 29,
    TELNET_TELOPT_X3PAD          = 30,
    TELNET_TELOPT_NAWS           = 31,
    TELNET_TELOPT_TSPEED         = 32,
    TELNET_TELOPT_LFLOW          = 33,
    TELNET_TELOPT_LINEMODE       = 34,
    TELNET_TELOPT_XDISPLOC       = 35,
    TELNET_TELOPT_ENVIRON        = 36,
    TELNET_TELOPT_AUTHENTICATION = 37,
    TELNET_TELOPT_ENCRYPT        = 38,
    TELNET_TELOPT_NEW_ENVIRON    = 39,
    TELNET_TELOPT_MSSP           = 70,
    TELNET_TELOPT_COMPRESS       = 85,
    TELNET_TELOPT_COMPRESS2      = 86,
    TELNET_TELOPT_ZMP            = 93,
    TELNET_TELOPT_EXOPL          = 255,
    TELNET_TELOPT_MCCP2          = 86
  end

  enum TerminalType : UInt8
    TELNET_TTYPE_IS   = 0,
    TELNET_TTYPE_SEND = 1
  end

  enum EnvironType : UInt8
    TELNET_ENVIRON_IS      = 0,
    TELNET_ENVIRON_SEND    = 1,
    TELNET_ENVIRON_INFO    = 2,
    TELNET_ENVIRON_VAR     = 0,
    TELNET_ENVIRON_VALUE   = 1,
    TELNET_ENVIRON_ESC     = 2,
    TELNET_ENVIRON_USERVAR = 3
  end

  enum MSSPType : UInt8
    TELNET_MSSP_VAR = 1,
    TELNET_MSSP_VAL = 2
  end

  enum EventType
    TELNET_EV_DATA = 0,        # raw text data has been received 
    TELNET_EV_SEND,            # data needs to be sent to the peer 
    TELNET_EV_IAC,             # generic IAC code received 
    TELNET_EV_WILL,            # WILL option negotiation received 
    TELNET_EV_WONT,            # WONT option neogitation received 
    TELNET_EV_DO,              # DO option negotiation received 
    TELNET_EV_DONT,            # DONT option negotiation received 
    TELNET_EV_SUBNEGOTIATION,  # sub-negotiation data received 
    TELNET_EV_COMPRESS,        # compression has been enabled 
    TELNET_EV_ZMP,             # ZMP command has been received 
    TELNET_EV_TTYPE,           # TTYPE command has been received 
    TELNET_EV_ENVIRON,         # ENVIRON command has been received 
    TELNET_EV_MSSP,            # MSSP command has been received 
    TELNET_EV_WARNING,         # recoverable error has occured
    TELNET_EV_ERROR            # non-recoverable error has occured
  end

  enum ErrorType
    TELNET_EOK = 0,            # no error
    TELNET_EBADVAL,            # invalid parameter, or API misuse
    TELNET_ENOMEM,             # memory allocation failure
    TELNET_EOVERFLOW,          # data exceeds buffer size
    TELNET_EPROTOCOL,          # invalid sequence of special bytes
    TELNET_ECOMPRESS           # error handling compressed streams
  end

  struct Data
    type   : EventType
    buffer : LibC::Char*
    size   : LibC::SizeT
  end

  struct Error
    type    : EventType
    file    : LibC::Char*
    func    : LibC::Char*
    msg     : LibC::Char*
    line    : Int32
    errcode : ErrorType
  end

  struct IAC
    type : EventType
    cmd  : Command
  end

  struct Negotiate
    type   : EventType
    telopt : Option
  end

  struct Subnegotiate
    type   : EventType
    buffer : LibC::Char*
    size   : LibC::SizeT
    telopt : Option
  end

  struct ZMP
    type   : EventType
    argv   : LibC::Char**
    argc   : LibC::SizeT
  end

  struct TType
    type : EventType
    cmd  : TerminalType    
    name : LibC::Char*
  end

  struct Compress
    type  : EventType
    state : UInt8      
  end

  struct TelnetEnvironType
    type  : EnvironType
    var   : LibC::Char*
    value : LibC::Char*
  end

  struct Environ
    type   : EventType  
    values : TelnetEnvironType*
    size   : LibC::SizeT
    cmd    : EnvironType    
  end

  struct MSSP
    type   : EventType
    values : TelnetEnvironType*
    size   : LibC::SizeT 
  end

  union TelnetEvent
    type         : EventType
    data         : Data
    error        : Error
    negotiate    : Negotiate
    subnegotiate : Subnegotiate
    zmp          : ZMP
    ttype        : TType
    compress     : Compress
    environ      : Environ
    mssp         : MSSP
  end

  fun telnet_init(telopts : TelOpt*, eh : (Telnet*, TelnetEvent*, UserData* ->), flags : UInt8, user_data : UserData*) : Telnet*
  fun telnet_free(Telnet*)

  fun telnet_recv(Telnet*, LibC::Char*, LibC::SizeT, UserData*)
  fun telnet_iac(Telnet*, Command)
  fun telnet_negotiate(Telnet*, Command, Option)
  fun telnet_send(Telnet*, LibC::Char*, LibC::SizeT)
  fun telnet_send_text(Telnet*, LibC::Char*, LibC::SizeT)
  fun telnet_begin_sb(Telnet*, Option)
  fun telnet_finish_sb(Telnet*)
  fun telnet_subnegotiation(Telnet*, Option, LibC::Char*, LibC::SizeT)
  fun telnet_printf(Telnet*, LibC::Char*, ...)
end

