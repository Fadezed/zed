package com.bright.zed.model.Bo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * 后台统计对象
 * @author zed
 */
@Data
@ToString
public class StatisticsBo implements Serializable {
    /**
     * 文章列表
     */
    private Long articles;
    /**
     * 内容
     */
    private Long comments;
    /**
     * 链接
     */
    private Long links;
    /**
     * 附件
     */
    private Long attachs;

}
