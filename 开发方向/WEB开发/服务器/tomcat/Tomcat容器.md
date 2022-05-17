# Tomcat 容器 <small>9.0.x</small>

## 选择并下载

官网：https://tomcat.apache.org/

通过 [which version](https://tomcat.apache.org/whichversion.html) 中的说明选择版本，并下载。

## 配置文件

### tomcat 用户

`%TOMCAT_HOME%/conf/tomcat-user.xml`

``` xml
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<!--
  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary.

  默认情况下，操作 "/manager/html" web 应用程序所需的 "manager-gui" 角色中不包括任何用户。
  如果你想使用这个应用，你必须定义这样一个用户 —— 用户名和密码是任意的。

  Built-in Tomcat manager roles:
    - manager-gui    - allows access to the HTML GUI and the status pages 允许访问HTML GUI和状态页面
    - manager-script - allows access to the HTTP API and the status pages 允许访问HTTP API和状态页面
    - manager-jmx    - allows access to the JMX proxy and the status pages 允许访问JMX代理和状态页面
    - manager-status - allows access to the status pages only 只允许访问状态页面

  The users below are wrapped in a comment and are therefore ignored. If you
  wish to configure one or more of these users for use with the manager web
  application, do not forget to remove the <!.. ..> that surrounds them. You
  will also need to set the passwords to something appropriate.
  
  下面的用户被包在注释中，因此被忽略。
  如果你希望将其中一个或多个用户配置为与 manager web应用程序一起使用，请不要忘记删除围绕这些用户的 <!.. ..>。
  你还需要将密码设置为适当的值。
-->
<!--
  <user username="admin" password="<must-be-changed>" roles="manager-gui"/>
  <user username="robot" password="<must-be-changed>" roles="manager-script"/>
-->
<!--
  NOTE:  The sample user and role entries below are intended for use with the
  examples web application. They are wrapped in a comment and thus are ignored
  when reading this file. If you wish to configure these users for use with the
  examples web application, do not forget to remove the <!.. ..> that surrounds
  them. You will also need to set the passwords to something appropriate.

  注意：下面的示例用户和角色条目用于示例 web 应用程序。它们被包在注释中，因此在读取此文件时会被忽略。
  如果你希望将这些用户配置为与示例 web 应用程序一起使用，请不要忘记删除它们周围的 <!.. ..>。
  你还需要将密码设置为适当的值。
-->
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="<must-be-changed>" roles="tomcat"/>
  <user username="both" password="<must-be-changed>" roles="tomcat,role1"/>
  <user username="role1" password="<must-be-changed>" roles="role1"/>
-->
</tomcat-users>
```

!> 不安全的用户名和密码，不应该用于生产环境或面向公众的服务器上。

请注意，对于Tomcat7以后的版本，使用`manager`应用程序所需的角色已从单个`manager`角色更改为以下四个角色。你需要为希望访问的功能分配所需的角色。

HTML接口受CSRF保护，但文本和JMX接口不受保护。要维护CSRF保护，请执行以下操作：

* 具有`manager-gui`角色的用户不应被授予 `manager-script`或 `manager-jmx` 角色。
* 如果通过浏览器访问文本或 jmx 接口（例如，用于测试，因为这些接口用于工具而非人类），则随后必须关闭浏览器以终止会话。



### 公共部署描述符文件

`%TOMCAT_HOME%/conf/web.xml`

主要内容：

* Servlet（default、JSP、SSI、CGI）
* 过滤器（HTTP头安全性、字符编码、失败请求、SSI）、
* 会话配置、
* MIME类型映射、
* 欢迎文件列表

``` xml
<web-app version="4.0" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee                       http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd">

  <!-- ======================== Introduction ============================== -->
  <!-- This document defines default values for *all* web applications      -->
  <!-- loaded into this instance of Tomcat.  As each application is         -->
  <!-- deployed, this file is processed, followed by the                    -->
  <!-- "/WEB-INF/web.xml" deployment descriptor from your own               -->
  <!-- applications.                                                        -->
  <!-- 本文档定义了加载到此 Tomcat 实例中的*所有*web应用程序的默认值。            -->
  <!-- 在部署每个应用程序时，都会处理此文件，然后是来自你自己的应用程序的 "/WEB-INF/web.xml" 部署描述符。-->
  <!--                                                                      -->
  <!-- WARNING:  Do not configure application-specific resources here!      -->
  <!-- They should go in the "/WEB-INF/web.xml" file in your application.   -->
  <!-- 警告：请勿在此配置特定于应用程序的资源！它们应该放在应用程序中的 "/WEB-INF/web.xml" 文件中。 -->
 
  <!-- ================== Built In Servlet Definitions ==================== -->


  <!-- The default servlet for all web applications, that serves static     -->
  <!-- resources.  It processes all requests that are not mapped to other   -->
  <!-- servlets with servlet mappings (defined either here or in your own   -->
  <!-- web.xml file).  This servlet supports the following initialization   -->
  <!-- parameters (default values are in square brackets):                  -->
  <!-- 所有 web 应用程序的默认servlet，用于提供静态资源。                       -->
  <!-- 它处理所有未映射到具有 servlet 映射（在此处或你自己的 web.xml 文件中定义）的其他 servlet 的请求。-->
  <!-- 此 servlet 支持以下初始化参数（默认值在方括号中）：                       -->
  <!--                                                                      -->
  <!--   debug               Debugging detail level for messages logged     -->
  <!--                       by this servlet. Useful values are 0, 1, and   -->
  <!--                       11 where higher values mean more detail. [0]   -->
  <!--                                                                      -->
  <!--   fileEncoding        Encoding to be used to read static resources   -->
  <!--                       [platform default]                             -->
  <!--                                                                      -->
  <!--   useBomIfPresent     If a static file contains a byte order mark    -->
  <!--                       (BOM), should this be used to determine the    -->
  <!--                       file encoding in preference to fileEncoding.   -->
  <!--                       [true]                                         -->
  <!--                                                                      -->
  <!--   input               Input buffer size (in bytes) when reading      -->
  <!--                       resources to be served.  [2048]                -->
  <!--                                                                      -->
  <!--   listings            Should directory listings be produced if there -->
  <!--                       is no welcome file in this directory?  [false] -->
  <!--                       WARNING: Listings for directories with many    -->
  <!--                       entries can be slow and may consume            -->
  <!--                       significant proportions of server resources.   -->
  <!--                       如果此目录中没有欢迎文件，是否应生成目录列表？[false] -->
  <!--                       警告：包含多个条目的目录的列表可能会很慢，并且可能会占用大量服务器资源。-->
  <!--                                                                      -->
  <!--   output              Output buffer size (in bytes) when writing     -->
  <!--                       resources to be served.  [2048]                -->
  <!--                                                                      -->
  <!--   readonly            Is this context "read only", so HTTP           -->
  <!--                       commands like PUT and DELETE are               -->
  <!--                       rejected?  [true]                              -->
  <!--                                                                      -->
  <!--   readmeFile          File to display together with the directory    -->
  <!--                       contents. [null]                               -->
  <!--                                                                      -->
  <!--   sendfileSize        If the connector used supports sendfile, this  -->
  <!--                       represents the minimal file size in KB for     -->
  <!--                       which sendfile will be used. Use a negative    -->
  <!--                       value to always disable sendfile.  [48]        -->
  <!--                                                                      -->
  <!--   useAcceptRanges     Should the Accept-Ranges header be included    -->
  <!--                       in responses where appropriate? [true]         -->
  <!--                                                                      -->
  <!--  For directory listing customization. Checks localXsltFile, then     -->
  <!--  globalXsltFile, then defaults to original behavior.                 -->
  <!--                                                                      -->
  <!--   localXsltFile       Make directory listings an XML doc and         -->
  <!--                       pass the result to this style sheet residing   -->
  <!--                       in that directory. This overrides              -->
  <!--                       contextXsltFile and globalXsltFile[null]       -->
  <!--                                                                      -->
  <!--   contextXsltFile     Make directory listings an XML doc and         -->
  <!--                       pass the result to this style sheet which is   -->
  <!--                       relative to the context root. This overrides   -->
  <!--                       globalXsltFile[null]                           -->
  <!--                                                                      -->
  <!--   globalXsltFile      Site wide configuration version of             -->
  <!--                       localXsltFile. This argument must either be an -->
  <!--                       absolute or relative (to either                -->
  <!--                       $CATALINA_BASE/conf or $CATALINA_HOME/conf)    -->
  <!--                       path that points to a location below either    -->
  <!--                       $CATALINA_BASE/conf (checked first) or         -->
  <!--                       $CATALINA_HOME/conf (checked second).[null]    -->
  <!--                                                                      -->
  <!--   showServerInfo      Should server information be presented in the  -->
  <!--                       response sent to clients when directory        -->
  <!--                       listings is enabled? [true]                    -->
  <!--                                                                      -->
  <!--   allowPartialPut     Should the server treat an HTTP PUT request    -->
  <!--                       with a Range header as a partial PUT? Note     -->
  <!--                       that RFC 7233 clarified that Range headers are -->
  <!--                       only valid for GET requests. [true]            -->

    <servlet>
        <servlet-name>default</servlet-name>
        <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
        <init-param>
            <param-name>debug</param-name>
            <param-value>0</param-value>
        </init-param>
        <init-param>
            <param-name>listings</param-name>
            <param-value>false</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>


  <!-- The JSP page compiler and execution servlet, which is the mechanism  -->
  <!-- used by Tomcat to support JSP pages.  Traditionally, this servlet    -->
  <!-- is mapped to the URL pattern "*.jsp".  This servlet supports the     -->
  <!-- following initialization parameters (default values are in square    -->
  <!-- brackets):                                                           -->
  <!-- JSP页面编译器和执行servlet，这是Tomcat用来支持JSP页面的机制。             -->
  <!-- 传统上，这个servlet被映射到URL模式 "*.jsp"。                            -->
  <!-- 此servlet支持以下初始化参数（默认值在方括号中）：                         -->
  <!--                                                                      -->
  <!--   checkInterval       If development is false and checkInterval is   -->
  <!--                       greater than zero, background compilations are -->
  <!--                       enabled. checkInterval is the time in seconds  -->
  <!--                       between checks to see if a JSP page (and its   -->
  <!--                       dependent files) needs to  be recompiled. [0]  -->
  <!--                                                                      -->
  <!--   classdebuginfo      Should the class file be compiled with         -->
  <!--                       debugging information?  [true]                 -->
  <!--                                                                      -->
  <!--   classpath           What class path should I use while compiling   -->
  <!--                       generated servlets?  [Created dynamically      -->
  <!--                       based on the current web application]          -->
  <!--                                                                      -->
  <!--   compiler            Which compiler Ant should use to compile JSP   -->
  <!--                       pages.  See the jasper documentation for more  -->
  <!--                       information.   Ant应该使用哪个编译器编译JSP页面。 -->
  <!--                                                                      -->
  <!--   compilerSourceVM    Compiler source VM. [1.8]                      -->
  <!--                                                                      -->
  <!--   compilerTargetVM    Compiler target VM. [1.8]                      -->
  <!--                                                                      -->
  <!--   development         Is Jasper used in development mode? If true,   -->
  <!--                       the frequency at which JSPs are checked for    -->
  <!--                       modification may be specified via the          -->
  <!--                       modificationTestInterval parameter. [true]     -->
  <!--                                                                      -->
  <!--   displaySourceFragment                                              -->
  <!--                       Should a source fragment be included in        -->
  <!--                       exception messages? [true]                     -->
  <!--                                                                      -->
  <!--   dumpSmap            Should the SMAP info for JSR45 debugging be    -->
  <!--                       dumped to a file? [false]                      -->
  <!--                       False if suppressSmap is true                  -->
  <!--                                                                      -->
  <!--   enablePooling       Determines whether tag handler pooling is      -->
  <!--                       enabled. This is a compilation option. It will -->
  <!--                       not alter the behaviour of JSPs that have      -->
  <!--                       already been compiled. [true]                  -->
  <!--                                                                      -->
  <!--   engineOptionsClass  Allows specifying the Options class used to    -->
  <!--                       configure Jasper. If not present, the default  -->
  <!--                       EmbeddedServletOptions will be used.           -->
  <!--                       This option is ignored when running under a    -->
  <!--                       SecurityManager.                               -->
  <!--                                                                      -->
  <!--   errorOnUseBeanInvalidClassAttribute                                -->
  <!--                       Should Jasper issue an error when the value of -->
  <!--                       the class attribute in an useBean action is    -->
  <!--                       not a valid bean class?  [true]                -->
  <!--                                                                      -->
  <!--   fork                Tell Ant to fork compiles of JSP pages so that -->
  <!--                       a separate JVM is used for JSP page compiles   -->
  <!--                       from the one Tomcat is running in. [true]      -->
  <!--                                                                      -->
  <!--   genStringAsCharArray                                               -->
  <!--                       Should text strings be generated as char       -->
  <!--                       arrays, to improve performance in some cases?  -->
  <!--                       [false]                                        -->
  <!--                                                                      -->
  <!--   ieClassId           The class-id value to be sent to Internet      -->
  <!--                       Explorer when using <jsp:plugin> tags.         -->
  <!--                       [clsid:8AD9C840-044E-11D1-B3E9-00805F499D93]   -->
  <!--                                                                      -->
  <!--   javaEncoding        Java file encoding to use for generating java  -->
  <!--                       source files. [UTF8]                           -->
  <!--                                                                      -->
  <!--   keepgenerated       Should we keep the generated Java source code  -->
  <!--                       for each page instead of deleting it? [true]   -->
  <!--                                                                      -->
  <!--   mappedfile          Should we generate static content with one     -->
  <!--                       print statement per input line, to ease        -->
  <!--                       debugging?  [true]                             -->
  <!--                                                                      -->
  <!--   maxLoadedJsps       The maximum number of JSPs that will be loaded -->
  <!--                       for a web application. If more than this       -->
  <!--                       number of JSPs are loaded, the least recently  -->
  <!--                       used JSPs will be unloaded so that the number  -->
  <!--                       of JSPs loaded at any one time does not exceed -->
  <!--                       this limit. A value of zero or less indicates  -->
  <!--                       no limit. [-1]                                 -->
  <!--                                                                      -->
  <!--   jspIdleTimeout      The amount of time in seconds a JSP can be     -->
  <!--                       idle before it is unloaded. A value of zero    -->
  <!--                       or less indicates never unload. [-1]           -->
  <!--                                                                      -->
  <!--   modificationTestInterval                                           -->
  <!--                       Causes a JSP (and its dependent files) to not  -->
  <!--                       be checked for modification during the         -->
  <!--                       specified time interval (in seconds) from the  -->
  <!--                       last time the JSP was checked for              -->
  <!--                       modification. A value of 0 will cause the JSP  -->
  <!--                       to be checked on every access.                 -->
  <!--                       Used in development mode only. [4]             -->
  <!--                                                                      -->
  <!--   recompileOnFail     If a JSP compilation fails should the          -->
  <!--                       modificationTestInterval be ignored and the    -->
  <!--                       next access trigger a re-compilation attempt?  -->
  <!--                       Used in development mode only and is disabled  -->
  <!--                       by default as compilation may be expensive and -->
  <!--                       could lead to excessive resource usage.        -->
  <!--                       [false]                                        -->
  <!--                                                                      -->
  <!--   scratchdir          What scratch directory should we use when      -->
  <!--                       compiling JSP pages?  [default work directory  -->
  <!--                       for the current web application]               -->
  <!--                       This option is ignored when running under a    -->
  <!--                       SecurityManager.                               -->
  <!--                                                                      -->
  <!--   suppressSmap        Should the generation of SMAP info for JSR45   -->
  <!--                       debugging be suppressed?  [false]              -->
  <!--                                                                      -->
  <!--   trimSpaces          Should template text that consists entirely of -->
  <!--                       whitespace be removed from the output (true),  -->
  <!--                       replaced with a single space (single) or left  -->
  <!--                       unchanged (false)? Note that if a JSP page or  -->
  <!--                       tag file specifies a trimDirectiveWhitespaces  -->
  <!--                       value of true, that will take precedence over  -->
  <!--                       this configuration setting for that page/tag.  -->
  <!--                       [false]                                        -->
  <!--                                                                      -->
  <!--   xpoweredBy          Determines whether X-Powered-By response       -->
  <!--                       header is added by generated servlet.  [false] -->
  <!--                                                                      -->
  <!--   strictQuoteEscaping When scriptlet expressions are used for        -->
  <!--                       attribute values, should the rules in JSP.1.6  -->
  <!--                       for the escaping of quote characters be        -->
  <!--                       strictly applied? [true]                       -->
  <!--                                                                      -->
  <!--   quoteAttributeEL    When EL is used in an attribute value on a     -->
  <!--                       JSP page should the rules for quoting of       -->
  <!--                       attributes described in JSP.1.6 be applied to  -->
  <!--                       the expression? [true]                         -->

    <servlet>
        <servlet-name>jsp</servlet-name>
        <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
        <init-param>
            <param-name>fork</param-name>
            <param-value>false</param-value>
        </init-param>
        <init-param>
            <param-name>xpoweredBy</param-name>
            <param-value>false</param-value>
        </init-param>
        <load-on-startup>3</load-on-startup>
    </servlet>


  <!-- NOTE: An SSI Filter is also available as an alternative SSI          -->
  <!-- implementation. Use either the Servlet or the Filter but NOT both.   -->
  <!-- 注意：SSI过滤器也可作为替代SSI实现。使用Servlet或过滤器，但不能同时使用两者。-->
  <!--                                                                      -->
  <!-- Server Side Includes processing servlet, which processes SSI         -->
  <!-- directives in HTML pages consistent with similar support in web      -->
  <!-- servers like Apache.  Traditionally, this servlet is mapped to the   -->
  <!-- URL pattern "*.shtml".  This servlet supports the following          -->
  <!-- initialization parameters (default values are in square brackets):   -->
  <!-- Server Side Includes (服务器端嵌入) 处理 servlet，                     -->
  <!-- 它在 HTML 页面中处理 SSI 指令，与 Apache 等 web 服务器中的类似支持一致。  -->
  <!-- 传统上，这个servlet被映射到URL模式 "*.shtml"。                          -->
  <!-- 此servlet支持以下初始化参数（默认值在方括号中）：                         -->
  <!--                                                                      -->
  <!--   buffered            Should output from this servlet be buffered?   -->
  <!--                       (0=false, 1=true)  [0]                         -->
  <!--                                                                      -->
  <!--   debug               Debugging detail level for messages logged     -->
  <!--                       by this servlet.  [0]                          -->
  <!--                                                                      -->
  <!--   expires             The number of seconds before a page with SSI   -->
  <!--                       directives will expire.  [No default]          -->
  <!--                                                                      -->
  <!--   isVirtualWebappRelative                                            -->
  <!--                       Should "virtual" paths be interpreted as       -->
  <!--                       relative to the context root, instead of       -->
  <!--                       the server root? [false]                       -->
  <!--                                                                      -->
  <!--   inputEncoding       The encoding to assume for SSI resources if    -->
  <!--                       one is not available from the resource.        -->
  <!--                       [Platform default]                             -->
  <!--                                                                      -->
  <!--   outputEncoding      The encoding to use for the page that results  -->
  <!--                       from the SSI processing. [UTF-8]               -->
  <!--                                                                      -->
  <!--   allowExec           Is use of the exec command enabled? [false]    -->

<!--
    <servlet>
        <servlet-name>ssi</servlet-name>
        <servlet-class>
          org.apache.catalina.ssi.SSIServlet
        </servlet-class>
        <init-param>
          <param-name>buffered</param-name>
          <param-value>1</param-value>
        </init-param>
        <init-param>
          <param-name>debug</param-name>
          <param-value>0</param-value>
        </init-param>
        <init-param>
          <param-name>expires</param-name>
          <param-value>666</param-value>
        </init-param>
        <init-param>
          <param-name>isVirtualWebappRelative</param-name>
          <param-value>false</param-value>
        </init-param>
        <load-on-startup>4</load-on-startup>
    </servlet>
-->


  <!-- Common Gateway Includes (CGI) processing servlet, which supports     -->
  <!-- execution of external applications that conform to the CGI spec      -->
  <!-- requirements.  Typically, this servlet is mapped to the URL pattern  -->
  <!-- "/cgi-bin/*", which means that any CGI applications that are         -->
  <!-- executed must be present within the web application.  This servlet   -->
  <!-- supports the following initialization parameters (default values     -->
  <!-- are in square brackets):                                             -->
  <!-- 公共网关包括（CGI）处理servlet，它支持执行符合CGI规范要求的外部应用程序。   -->
  <!-- 通常，此servlet映射到URL模式"/cgi-bin/*"，这意味着执行的任何CGI应用程序都必须存在于web应用程序中。-->
  <!-- 此servlet支持以下初始化参数（默认值在方括号中）：                         -->
  <!--                                                                      -->
  <!--   cgiPathPrefix        The CGI search path will start at             -->
  <!--                        webAppRootDir + File.separator + this prefix. -->
  <!--                        If not set, then webAppRootDir is used.       -->
  <!--                        Recommended value: WEB-INF/cgi                -->
  <!--                                                                      -->
  <!--  cmdLineArgumentsDecoded                                             -->
  <!--                        Only used when enableCmdLineArguments is      -->
  <!--                        true. The pattern that individual decoded     -->
  <!--                        command line arguments must match else the    -->
  <!--                        request will be rejected. This is to          -->
  <!--                        work-around various issues when Java passes   -->
  <!--                        the arguments to the OS. See the CGI How-To   -->
  <!--                        for more details. The default varies by       -->
  <!--                        platform.                                     -->
  <!--                        Windows: [[a-zA-Z0-9\Q-_.\\/:\E]+]            -->
  <!--                        Others:  [.*]                                 -->
  <!--                        Note that internally the CGI Servlet treats   -->
  <!--                        [.*] as a special case to improve performance -->
  <!--                                                                      -->
  <!--   cmdLineArgumentsEncoded                                            -->
  <!--                        Only used when enableCmdLineArguments is      -->
  <!--                        true. The pattern that individual encoded     -->
  <!--                        command line arguments must match else the    -->
  <!--                        request will be rejected. The default matches -->
  <!--                        the allowed values defined by RFC3875.        -->
  <!--                        [[a-zA-Z0-9\Q%;/?:@&,$-_.!~*'()\E]+]          -->
  <!--                                                                      -->
  <!--   enableCmdLineArguments                                             -->
  <!--                        Are command line parameters generated from    -->
  <!--                        the query string as per section 4.4 of 3875   -->
  <!--                        RFC? [false]                                  -->
  <!--                                                                      -->
  <!--   executable           Name of the executable used to run the        -->
  <!--                        script. [perl]                                -->
  <!--                                                                      -->
  <!--   envHttpHeaders       A regular expression used to select the HTTP  -->
  <!--                        headers passed to the CGI process as          -->
  <!--                        environment variables. Note that headers are  -->
  <!--                        converted to upper case before matching and   -->
  <!--                        that the entire header name must match the    -->
  <!--                        pattern.                                      -->
  <!--                        [ACCEPT[-0-9A-Z]*|CACHE-CONTROL|COOKIE|HOST|  -->
  <!--                         IF-[-0-9A-Z]*|REFERER|USER-AGENT]            -->
  <!--                                                                      -->
  <!--  environment-variable- An environment to be set for the execution    -->
  <!--                        environment of the CGI script. The name of    -->
  <!--                        variable is taken from the parameter name.    -->
  <!--                        To configure an environment variable named    -->
  <!--                        FOO, configure a parameter named              -->
  <!--                        environment-variable-FOO. The parameter value -->
  <!--                        is used as the environment variable value.    -->
  <!--                        The default is no environment variables.      -->
  <!--                                                                      -->
  <!--   parameterEncoding    Name of parameter encoding to be used with    -->
  <!--                        CGI servlet.                                  -->
  <!--                        [System.getProperty("file.encoding","UTF-8")] -->
  <!--                                                                      -->
  <!--   passShellEnvironment Should the shell environment variables (if    -->
  <!--                        any) be passed to the CGI script? [false]     -->
  <!--                                                                      -->
  <!--   stderrTimeout        The time (in milliseconds) to wait for the    -->
  <!--                        reading of stderr to complete before          -->
  <!--                        terminating the CGI process. [2000]           -->

<!--
    <servlet>
        <servlet-name>cgi</servlet-name>
        <servlet-class>org.apache.catalina.servlets.CGIServlet</servlet-class>
        <init-param>
          <param-name>cgiPathPrefix</param-name>
          <param-value>WEB-INF/cgi</param-value>
        </init-param>
        <load-on-startup>5</load-on-startup>
    </servlet>
-->


  <!-- ================ Built In Servlet Mappings ========================= -->


  <!-- The servlet mappings for the built in servlets defined above.  Note  -->
  <!-- that, by default, the CGI and SSI servlets are *not* mapped.  You    -->
  <!-- must uncomment these mappings (or add them to your application's own -->
  <!-- web.xml deployment descriptor) to enable these services              -->
  <!-- 上面定义的内置servlet的servlet映射。                                   -->
  <!-- 注意，默认情况下，CGI 和 SSI servlet是*未*映射的。                      -->
  <!-- 必须取消注释这些映射（或将它们添加到应用程序自己的 web.xml部署描述符）才能启用这些服务 -->

    <!-- The mapping for the default servlet -->
    <servlet-mapping>
        <servlet-name>default</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <!-- The mappings for the JSP servlet -->
    <servlet-mapping>
        <servlet-name>jsp</servlet-name>
        <url-pattern>*.jsp</url-pattern>
        <url-pattern>*.jspx</url-pattern>
    </servlet-mapping>

    <!-- The mapping for the SSI servlet -->
<!--
    <servlet-mapping>
        <servlet-name>ssi</servlet-name>
        <url-pattern>*.shtml</url-pattern>
    </servlet-mapping>
-->

    <!-- The mapping for the CGI Gateway servlet -->

<!--
    <servlet-mapping>
        <servlet-name>cgi</servlet-name>
        <url-pattern>/cgi-bin/*</url-pattern>
    </servlet-mapping>
-->


  <!-- ================== Built In Filter Definitions ===================== -->

  <!-- A filter that sets various security related HTTP Response headers.   -->
  <!-- 过滤器，设置各种安全相关HTTP响应头。 -->
  <!-- This filter supports the following initialization parameters         -->
  <!-- (default values are in square brackets):                             -->
  <!--                                                                      -->
  <!--   hstsEnabled         Should the HTTP Strict Transport Security      -->
  <!--                       (HSTS) header be added to the response? See    -->
  <!--                       RFC 6797 for more information on HSTS. [true]  -->
  <!--                                                                      -->
  <!--   hstsMaxAgeSeconds   The max age value that should be used in the   -->
  <!--                       HSTS header. Negative values will be treated   -->
  <!--                       as zero. [0]                                   -->
  <!--                                                                      -->
  <!--   hstsIncludeSubDomains                                              -->
  <!--                       Should the includeSubDomains parameter be      -->
  <!--                       included in the HSTS header.                   -->
  <!--                                                                      -->
  <!--   antiClickJackingEnabled                                            -->
  <!--                       Should the anti click-jacking header           -->
  <!--                       X-Frame-Options be added to every response?    -->
  <!--                       [true]                                         -->
  <!--                                                                      -->
  <!--   antiClickJackingOption                                             -->
  <!--                       What value should be used for the header. Must -->
  <!--                       be one of DENY, SAMEORIGIN, ALLOW-FROM         -->
  <!--                       (case-insensitive). [DENY]                     -->
  <!--                                                                      -->
  <!--   antiClickJackingUri IF ALLOW-FROM is used, what URI should be      -->
  <!--                       allowed? []                                    -->
  <!--                                                                      -->
  <!--   blockContentTypeSniffingEnabled                                    -->
  <!--                       Should the header that blocks content type     -->
  <!--                       sniffing be added to every response? [true]    -->
<!--
    <filter>
        <filter-name>httpHeaderSecurity</filter-name>
        <filter-class>org.apache.catalina.filters.HttpHeaderSecurityFilter</filter-class>
        <async-supported>true</async-supported>
    </filter>
-->

  <!-- A filter that sets character encoding that is used to decode -->
  <!-- parameters in a POST request 设置用于解码POST请求中的参数的字符编码 -->
<!--
    <filter>
        <filter-name>setCharacterEncodingFilter</filter-name>
        <filter-class>org.apache.catalina.filters.SetCharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <async-supported>true</async-supported>
    </filter>
-->

  <!-- A filter that triggers request parameters parsing and rejects the    -->
  <!-- request if some parameters were skipped because of parsing errors or -->
  <!-- request size limitations.                                            -->
  <!-- 用于触发请求参数解析，并在由于解析错误或请求大小限制而跳过某些参数时拒绝请求。 -->
<!--
    <filter>
        <filter-name>failedRequestFilter</filter-name>
        <filter-class>
          org.apache.catalina.filters.FailedRequestFilter
        </filter-class>
        <async-supported>true</async-supported>
    </filter>
-->


  <!-- NOTE: An SSI Servlet is also available as an alternative SSI         -->
  <!-- implementation. Use either the Servlet or the Filter but NOT both.   -->
  <!--                                                                      -->
  <!-- Server Side Includes processing filter, which processes SSI          -->
  <!-- directives in HTML pages consistent with similar support in web      -->
  <!-- servers like Apache.  Traditionally, this filter is mapped to the    -->
  <!-- URL pattern "*.shtml", though it can be mapped to "*" as it will     -->
  <!-- selectively enable/disable SSI processing based on mime types. For   -->
  <!-- this to work you will need to uncomment the .shtml mime type         -->
  <!-- definition towards the bottom of this file.                          -->
  <!-- The contentType init param allows you to apply SSI processing to JSP -->
  <!-- pages, javascript, or any other content you wish.  This filter       -->
  <!-- supports the following initialization parameters (default values are -->
  <!-- in square brackets):                                                 -->
  <!--                                                                      -->
  <!--   contentType         A regex pattern that must be matched before    -->
  <!--                       SSI processing is applied.                     -->
  <!--                       [text/x-server-parsed-html(;.*)?]              -->
  <!--                                                                      -->
  <!--   debug               Debugging detail level for messages logged     -->
  <!--                       by this servlet.  [0]                          -->
  <!--                                                                      -->
  <!--   expires             The number of seconds before a page with SSI   -->
  <!--                       directives will expire.  [No default]          -->
  <!--                                                                      -->
  <!--   isVirtualWebappRelative                                            -->
  <!--                       Should "virtual" paths be interpreted as       -->
  <!--                       relative to the context root, instead of       -->
  <!--                       the server root? [false]                       -->
  <!--                                                                      -->
  <!--   allowExec           Is use of the exec command enabled? [false]    -->

<!--
    <filter>
        <filter-name>ssi</filter-name>
        <filter-class>
          org.apache.catalina.ssi.SSIFilter
        </filter-class>
        <init-param>
          <param-name>contentType</param-name>
          <param-value>text/x-server-parsed-html(;.*)?</param-value>
        </init-param>
        <init-param>
          <param-name>debug</param-name>
          <param-value>0</param-value>
        </init-param>
        <init-param>
          <param-name>expires</param-name>
          <param-value>666</param-value>
        </init-param>
        <init-param>
          <param-name>isVirtualWebappRelative</param-name>
          <param-value>false</param-value>
        </init-param>
    </filter>
-->


  <!-- ==================== Built In Filter Mappings ====================== -->

  <!-- The mapping for the HTTP header security Filter -->
<!--
    <filter-mapping>
        <filter-name>httpHeaderSecurity</filter-name>
        <url-pattern>/*</url-pattern>
        <dispatcher>REQUEST</dispatcher>
    </filter-mapping>
-->

  <!-- The mapping for the Set Character Encoding Filter -->
<!--
    <filter-mapping>
        <filter-name>setCharacterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
-->

  <!-- The mapping for the Failed Request Filter -->
<!--
    <filter-mapping>
        <filter-name>failedRequestFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
-->

  <!-- The mapping for the SSI Filter -->
<!--
    <filter-mapping>
        <filter-name>ssi</filter-name>
        <url-pattern>*.shtml</url-pattern>
    </filter-mapping>
-->


  <!-- ==================== Default Session Configuration ================= -->
  <!-- You can set the default session timeout (in minutes) for all newly   -->
  <!-- created sessions by modifying the value below.                       -->
  <!-- 通过修改以下值，可以为所有新创建的会话设置默认会话超时（单位：分钟）。       -->

    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>


  <!-- ===================== Default MIME Type Mappings =================== -->
  <!-- When serving static resources, Tomcat will automatically generate    -->
  <!-- a "Content-Type" header based on the resource's filename extension,  -->
  <!-- based on these mappings.  Additional mappings can be added here (to  -->
  <!-- apply to all web applications), or in your own application's web.xml -->
  <!-- deployment descriptor.                                               -->
  <!-- Note: Extensions are always matched in a case-insensitive manner.    -->
  <!-- 在提供静态资源时，Tomcat 将根据这些映射，根据资源的文件扩展名自动生成一个"Content-Type"头。-->
  <!-- 可以在此处（应用于所有 web 应用程序）或你自己的应用程序的 web.xml 部署描述符中添加其他映射。-->
  <!-- 注意：扩展总是以不区分大小写的方式匹配。-->
  <!-- 原文档内容太多，只保留一个做格式展示 -->

    <mime-mapping>
        <extension>123</extension>
        <mime-type>application/vnd.lotus-1-2-3</mime-type>
    </mime-mapping>

  <!-- ==================== Default Welcome File List ===================== -->
  <!-- When a request URI refers to a directory, the default servlet looks  -->
  <!-- for a "welcome file" within that directory and, if present, to the   -->
  <!-- corresponding resource URI for display.                              -->
  <!-- 当请求URI引用目录时，默认servlet在该目录中查找“欢迎文件”，如果存在，则查找相应的资源URI以显示。 -->
  <!-- If no welcome files are present, the default servlet either serves a -->
  <!-- directory listing (see default servlet configuration on how to       -->
  <!-- customize) or returns a 404 status, depending on the value of the    -->
  <!-- listings setting.                                                    -->
  <!-- 如果不存在欢迎文件，默认servlet要么提供目录列表（请参阅有关如何自定义的默认servlet配置），要么返回404状态，具体取决于列表设置的值。 -->
  <!--                                                                      -->
  <!-- If you define welcome files in your own application's web.xml        -->
  <!-- deployment descriptor, that list *replaces* the list configured      -->
  <!-- here, so be sure to include any of the default values that you wish  -->
  <!-- to use within your application.                                       -->
  <!-- 如果在自己的应用程序的 web.xml 部署描述符中定义欢迎文件，则该列表*将替换*此处配置的列表，-->
  <!-- 因此请确保包含希望在应用程序中使用的任何默认值。 -->

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.htm</welcome-file>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

</web-app>
```

## 用户手册

### 类加载器

#### 概述

与许多服务器应用程序一样，Tomcat安装了各种类加载器（即实现`java.lang.ClassLoader`的类），以允许容器的不同部分以及容器上运行的web应用程序访问可用类和资源的不同存储库。此机制用于提供Servlet规范2.4版中定义的功能，特别是第9.4节和第9.6节。

在Java环境中，类加载器被安排在父子树中。通常，当类加载器被要求加载特定的类或资源时，它会首先将请求委托给父类加载器，然后仅在父类加载器找不到请求的类或资源时才查找自己的存储库。请注意，web应用程序类加载器的模型与此略有不同，如下所述，但主要原则是相同的。

启动Tomcat时，它会创建一组类加载器，这些类加载器被组织成以下父子关系，其中父类加载器位于子类加载器之上：

下面一节将详细讨论每个类加载器的特征，包括它们所显示的类和资源的源。

#### 类加载器定义

如上图所示，Tomcat在初始化时创建以下类加载器：

* Bootstrap：这个类加载器包含Java虚拟机提供的基本运行时类，以及系统扩展目录（`$Java_HOME/jre/lib/ext`）中JAR文件中的任何类。注意：一些JVM可能将其实现为多个类加载器，或者它可能根本不可见（作为类装入器）。
* System：这个类加载器通常是从`CLASSPATH`环境变量的内容初始化的。所有这些类对Tomcat内部类和web应用程序都是可见的。但是，标准Tomcat启动脚本（`$CATALINA_HOME/bin/catalina.sh`或`%CATALINA_HOME%\bin\catalina.bat`）完全忽略`CLASSPATH`环境变量本身的内容，而是从以下存储库构建系统类加载器：
  * `$CATALINA_HOME/bin/bootstrap.jar`：包含用于初始化Tomcat服务器的 `main()` 方法，以及它所依赖的类加载器实现类。
    * `$CATALINA_BASE/bin/tomcat-juli.jar` 或者 `$CATALINA_HOME/bin/tomcat-juli.jar`：
  * `$CATALINA_HOME/bin/commons-daemon.jar`：[Apache Commons Daemon](https://commons.apache.org/daemon/) 项目中的类。这个JAR文件不在 `catalina.bat` | `.sh` 脚本构建的 `CLASSPATH` 中，是从 *bootstrap.jar* 的清单文件中引用的。

如上所述，web应用程序类加载器与默认Java委派模型不同（根据Servlet规范2.4版第9.7.2节web应用程序类加载器中的建议）。当处理从web应用程序的 *WebappX* 类加载器加载类的请求时，该类加载器将首先查找本地存储库，而不是在查找之前进行委派。也有例外。不能重写属于JRE基类的类。也有一些例外情况，例如XML解析器组件，可以使用适当的JVM功能（Java<=8的认可标准覆盖功能）和Java 9+的可升级模块功能来覆盖这些组件。最后，web应用程序类加载器将始终首先为Tomcat实现的规范（Servlet、JSP、EL、WebSocket）的JavaEEAPI类进行委托。Tomcat中的所有其他类加载器都遵循通常的委托模式。

