package com.bright.zed.intercepter;

import com.bright.zed.MapCache;
import com.bright.zed.common.AdminCommons;
import com.bright.zed.common.Commons;
import com.bright.zed.common.IPKit;
import com.bright.zed.common.TaleUtils;
import com.bright.zed.constant.WebConst;
import com.bright.zed.dto.Types;
import com.bright.zed.id.IdUtil;
import com.bright.zed.model.Vo.UserVo;
import com.bright.zed.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 自定义拦截器
 * @author zed
 */
@Slf4j
@Component
public class BaseInterceptor implements HandlerInterceptor {
    private static final String USER_AGENT = "user-agent";

    @Resource
    private IUserService userService;

    private MapCache cache = MapCache.single();

    @Resource
    private Commons commons;

    @Resource
    private AdminCommons adminCommons;


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        String uri = request.getRequestURI();

        log.info("UserAgent: {}", request.getHeader(USER_AGENT));
        log.info("用户访问地址: {}, 来路地址: {}", uri, IPKit.getIpAddrByRequest(request));

        //请求拦截处理
        UserVo user = TaleUtils.getLoginUser(request);
        if (null == user) {
            Integer uid = TaleUtils.getCookieUid(request);
            if (null != uid) {
                //这里还是有安全隐患,cookie是可以伪造的
                user = userService.queryUserById(uid);
                request.getSession().setAttribute(WebConst.LOGIN_SESSION_KEY, user);
            }
        }
        if (uri.startsWith("/back") && !uri.startsWith("/back/login") && null == user) {
            response.sendRedirect(request.getContextPath() + "/back/login");
            return false;
        }
        //设置get请求的token
        if ("GET".equals(request.getMethod())) {
            String token = IdUtil.getUUID();
            // 默认存储30分钟
            cache.hset(Types.CSRF_TOKEN.getType(), token, uri, 30 * 60);
            request.setAttribute("_csrf_token", token);
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
        //一些工具类和公共方法
        httpServletRequest.setAttribute("commons", commons);
        httpServletRequest.setAttribute("adminCommons", adminCommons);
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
