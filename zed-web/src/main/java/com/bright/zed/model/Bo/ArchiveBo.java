package com.bright.zed.model.Bo;


import com.bright.zed.model.Vo.ContentVo;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * 描述:
 * 档案
 *
 * @author zed
 * @since 2019-01-02 8:21 PM
 */
@Data
@ToString
public class ArchiveBo implements Serializable {
    /**
     * 时间
     */
    private String date;
    /**
     * cout
     */
    private String count;
    /**
     * 文章列表
     */
    private List<ContentVo> articles;

}
