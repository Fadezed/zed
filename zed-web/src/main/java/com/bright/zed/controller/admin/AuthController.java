package com.bright.zed.controller.admin;

import com.bright.zed.common.Commons;
import com.bright.zed.common.TaleUtils;
import com.bright.zed.constant.WebConst;
import com.bright.zed.controller.BaseController;
import com.bright.zed.dto.LogActions;
import com.bright.zed.exception.TipException;
import com.bright.zed.model.bo.RestResponseBo;
import com.bright.zed.model.vo.UserVo;
import com.bright.zed.service.ILogService;
import com.bright.zed.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户后台登录/登出
 * @author zed
 */
@Slf4j
@Controller
@RequestMapping("/back")
@Transactional(rollbackFor = TipException.class)
public class AuthController extends BaseController {

    @Resource
    private IUserService usersService;

    @Resource
    private ILogService logService;

    @GetMapping(value = "/login")
    public String login() {
        return "admin/login";
    }

    /**
     * 管理后台登录
     * @param username user
     * @param password pa
     * @param remember r
     * @param request re
     * @param response re
     * @return s
     */
    @PostMapping(value = "login")
    @ResponseBody
    public RestResponseBo doLogin(@RequestParam String username,
                                  @RequestParam String password,
                                  @RequestParam(required = false) String remember,
                                  HttpServletRequest request,
                                  HttpServletResponse response) {

        Integer errorCount = cache.get("login_error_count");
        try {
            UserVo user = usersService.login(username, password);
            request.getSession().setAttribute(WebConst.LOGIN_SESSION_KEY, user);
            if (StringUtils.isNotBlank(remember)) {
                TaleUtils.setCookie(response, user.getUid());
            }
            logService.insertLog(LogActions.LOGIN.getAction(), null, request.getRemoteAddr(), user.getUid());
        } catch (Exception e) {
            errorCount = null == errorCount ? 1 : errorCount + 1;
            if (errorCount > 3) {
                return RestResponseBo.fail("您输入密码已经错误超过3次，请10分钟后尝试");
            }
            cache.set("login_error_count", errorCount, 10 * 60);
            String msg = "登录失败";
            if (e instanceof TipException) {
                msg = e.getMessage();
            } else {
                log.error(msg, e);
            }
            return RestResponseBo.fail(msg);
        }
        return RestResponseBo.ok();
    }

    /**
     * 注销
     * @param session se
     * @param response re
     */
    @GetMapping("/logout")
    public void logout(HttpSession session, HttpServletResponse response, HttpServletRequest request) {
        session.removeAttribute(WebConst.LOGIN_SESSION_KEY);
        Cookie cookie = new Cookie(WebConst.USER_IN_COOKIE, "");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        try {
            response.sendRedirect(Commons.getSiteUrl());
        } catch (IOException e) {
            log.error("注销失败", e);
        }
    }
}
