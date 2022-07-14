# 验证码

## hutool-captcha

> https://www.hutool.cn/docs/#/captcha/%E6%A6%82%E8%BF%B0

``` xml
<!-- https://mvnrepository.com/artifact/cn.hutool/hutool-captcha -->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-captcha</artifactId>
            <version>5.8.4</version>
        </dependency>
```

### CaptchaServlet

``` java
@WebServlet(name = "mathShearCaptcha", urlPatterns = {"/mathShearcaptcha"})
public class MathShearCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置
        ShearCaptcha shearCaptcha = CaptchaUtil.createShearCaptcha(200, 100);
        shearCaptcha.setGenerator(new MathGenerator(1));
        // 生成并输出
        shearCaptcha.write(resp.getOutputStream());
        // 保存的会话域
        req.getSession().setAttribute("captcha", shearCaptcha);
    }
}
```

内置四种干扰模式：线干扰 `CaptchaUtil.createLineCaptcha`、圆圈干扰 `CaptchaUtil.createCircleCaptcha`、扭曲干扰 `CaptchaUtil.createShearCaptcha`、动图干扰 `CaptchaUtil.createGifCaptcha`

内置两个验证码生成器 `CodeGenerator`，分别是随机字符验证码生成器 `RandomGenerator` 和算术运算验证码生成器 `MathGenerator`。默认使用字母数字随机字符生成器。可以自定义生成器，并用 `void setGenerator(CodeGenerator generator)` 设置使用。

### 简单模拟登录

#### login.jsp

``` jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>hello captcha</title>
</head>
<body>
    <jsp:text>${pageContext.request.getAttribute("error")}</jsp:text>
    <form action="${pageContext.request.contextPath}/login" method="post" >
        <label title="验证码：" for="captcha" content="验证码：">
            <input id="captcha" type="text" name="captcha" value="" />
        </label>
    </form>
    <img src="${pageContext.request.contextPath}/mathShearcaptcha"  alt="验证码"/>
</body>
</html>
```

#### LoginServlet

``` java
@WebServlet(
        name = "login",
        urlPatterns = {"/login"}
)
public class LoginServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String userCaptcha = req.getParameter("captcha");
        ICaptcha captcha = (ICaptcha) req.getSession().getAttribute("captcha");
        if (captcha.verify(userCaptcha)) {
            resp.sendRedirect("success.jsp");
        } else {
            req.setAttribute("error", "验证失败！");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
```

#### success.jsp

``` jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>login success</title>
</head>
<body>
    验证成功！！
</body>
</html>
```



## easy-captcha

引入 jar 包。

``` xml
<!-- https://mvnrepository.com/artifact/com.github.whvcse/easy-captcha -->
        <dependency>
            <groupId>com.github.whvcse</groupId>
            <artifactId>easy-captcha</artifactId>
            <version>1.6.2</version>
        </dependency>
```

### CaptchaServlet

#### 英文数字

``` java
@WebServlet(name = "specCaptcha", urlPatterns = {"/specCaptcha"})
public class SpecCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CaptchaUtil.out(new SpecCaptcha(), req, resp);
    }
}
```

#### 英文数字动图

``` java
@WebServlet(name = "gifCaptcha", urlPatterns = {"/gifCaptcha"})
public class GifCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CaptchaUtil.out(new GifCaptcha(), req, resp);
    }
}
```

#### 中文字符

``` java
@WebServlet(name = "chineseCaptcha", urlPatterns = {"/chineseCaptcha"})
public class ChineseCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CaptchaUtil.out(new ChineseCaptcha(), req, resp);
    }
}
```

#### 中文字符动图

``` java
@WebServlet(name = "chineseGifCaptcha", urlPatterns = {"/chineseGifCaptcha"})
public class ChineseGifCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CaptchaUtil.out(new ChineseGifCaptcha(), req, resp);
    }
}
```

#### 算术表达式

``` java
@WebServlet(name = "arithmeticCaptcha", urlPatterns = {"/arithmeticCaptcha"})
public class ArithmeticCaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CaptchaUtil.out(new ArithmeticCaptcha(), req, resp);
    }
}
```

### 简单模拟登录

#### login.jsp

同上，只需要改一下 `img` 标签的 `src` 元素值即可，略。

#### LoginServlet

``` java
@WebServlet(
        name = "login",
        urlPatterns = {"/login"}
)
public class LoginServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String captcha = (String) req.getSession().getAttribute("captcha");
        req.setCharacterEncoding("UTF-8");
        String userCaptcha = req.getParameter("captcha").toLowerCase(Locale.ROOT);
        if (Objects.equals(captcha, userCaptcha)) {
            resp.sendRedirect("success.jsp");
        } else {
            req.setAttribute("error", "验证码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
```

#### success.jsp

同上，略。

## anji-plus-captcha 行为验证码

> 源码：https://gitee.com/anji-plus/captcha
>
> 文档：https://ajcaptcha.beliefteam.cn/captcha-doc/

 AJ-Captcha行为验证码，包含滑动拼图、文字点选两种方式，UI支持弹出和嵌入两种方式。后端提供Java实现，前端提供了php、angular、html、vue、uni-app、flutter、android、ios等代码示例。

## dustlight-captcha

``` xml
<!-- https://mvnrepository.com/artifact/cn.dustlight.captcha/captcha-core -->
<dependency>
    <groupId>cn.dustlight.captcha</groupId>
    <artifactId>captcha-core</artifactId>
    <version>1.0.1</version>
</dependency>
```

一个基于 **Spring Boot** 框架的验证码框架，它通过 AOP 的方式完成包含验证码生成、发送、存储等验证码相关业务，以避免与业务代码耦合。 开发者可以轻松地通过不同组件的组合来完成验证业务，同时可以进行自定义实现以应对自身的业务需求（例如邮箱验证码、短信验证码）。
