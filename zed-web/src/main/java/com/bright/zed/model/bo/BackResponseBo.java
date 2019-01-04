package com.bright.zed.model.bo;

import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

/**
 * 描述:
 * 档案
 *
 * @author zed
 * @since 2019-01-01 8:21 PM
 */
@Data
@ToString
public class BackResponseBo implements Serializable {
    /**
     * 附件路径
     */
    private String attachPath;
    /**
     * 主题path
     */
    private String themePath;
    /**
     * sql path
     */
    private String sqlPath;


}
