package com.bright.zed.http;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultRedirectStrategy;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.*;

/**
 * 描述:
 * webClient
 *
 * @author zed
 * @since 2019-01-02 7:56 PM
 */
@Slf4j
public class WebClient {

    private static WebClient webClient;
    /**
     * HTTP连接超时时间
     */
    private static final int CONNECT_TIMEOUT = 20000;

    /**
     * HTTP套接字SOCKET超时时间
     */
    private static final int SOCKET_TIMEOUT = 20000;
    /**
     * 连接池管理对象
     */
    private static PoolingHttpClientConnectionManager connectionManager = null;

    public static WebClient getInstance() {
        if (webClient == null) {
            webClient = new WebClient();
        }
        return webClient;
    }
    private static CloseableHttpClient createInstance() {

        DefaultRedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

        RequestConfig requestConfig =
                RequestConfig.custom()
                        .setConnectTimeout(WebClient.CONNECT_TIMEOUT)
                        .setSocketTimeout(WebClient.SOCKET_TIMEOUT)
                        .setConnectionRequestTimeout(WebClient.CONNECT_TIMEOUT)
                        .setRedirectsEnabled(true)
                        .setCookieSpec("easy")
                        .build();

        return HttpClients.custom()
                .setConnectionManager(connectionManager)
                .setDefaultRequestConfig(requestConfig)
                .setRedirectStrategy(redirectStrategy)
                .setUserAgent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1;.NET CLR 1.1.4322; CIBA; .NET CLR 2.0.50727)")
                .build();
    }

    /**
     * 发送post请求
     * @param url 请求的URL
     * @param params 请求参数
     * @return String URL响应字符串
     */
    public static String post(String url, Map<String, String> params) {
        CloseableHttpClient httpclient;
        HttpPost httppost = new HttpPost(url);
        try {
            httpclient = createInstance();
            if(params == null || params.size() == 0) {
                return "";
            }

            // 创建参数队列
            List<NameValuePair> formParams = new ArrayList<>();
            for (String key : params.keySet()) {
                formParams.add(new BasicNameValuePair(key, params.get(key)));
            }
            UrlEncodedFormEntity uefEntity = new UrlEncodedFormEntity(formParams, "UTF-8");
            httppost.setEntity(uefEntity);

            HttpResponse response;
            response = httpclient.execute(httppost);

            if(response == null) {
                return "";
            }
            HttpEntity entity = response.getEntity();
            if(entity != null) {
                return EntityUtils.toString(entity, "UTF-8");
            }
        } catch (Exception e) {
            log.error("post error:{}",e);
        } finally {
            httppost.releaseConnection();
        }
        return "";
    }

    public String postJsonData(String url, String jsonStrData, HashMap<String, Object> params) throws IOException {
        HttpPost post = new HttpPost(url);
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        int socketOut = 20000;
        int connOut = 20000;
        if (params != null) {
            if (params.containsKey("soketOut")) {
                socketOut = Integer.valueOf(params.get("socketOut") + "");
            }
            if (params.containsKey("connOut")) {
                connOut = Integer.valueOf(params.get("connOut") + "");
            }
            if (params.containsKey("Authorization")) {
                post.setHeader("Authorization", params.get("Authorization") + "");
            }

        }
        // 设置请求和传输超时时间
        RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(socketOut).setConnectTimeout(connOut).build();
        post.setConfig(requestConfig);
        HttpEntity entity = new StringEntity(jsonStrData, "UTF-8");
        post.setEntity(entity);
        post.setHeader("Content-type", "application/json");
        HttpResponse resp = closeableHttpClient.execute(post);
        InputStream respIs = resp.getEntity().getContent();
        byte[] respBytes = IOUtils.toByteArray(respIs);
        return new String(respBytes, Charset.forName("UTF-8"));
    }
}

