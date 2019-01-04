package com.bright.zed;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author zed
 */
public class DateKit {
    public static final int INTERVAL_DAY = 1;
    public static final int INTERVAL_WEEK = 2;
    public static final int INTERVAL_MONTH = 3;
    public static final int INTERVAL_YEAR = 4;
    public static final int INTERVAL_HOUR = 5;
    public static final int INTERVAL_MINUTE = 6;
    public static final int INTERVAL_SECOND = 7;
    public DateKit() {
    }

    public static Date dateFormat(String date, String dateFormat) {
        if(date == null) {
            return null;
        } else {
            SimpleDateFormat format = new SimpleDateFormat(dateFormat);
            try {
                return format.parse(date);
            } catch (Exception ignored) {
            }

            return null;
        }
    }

    public static String dateFormat(Date date, String dateFormat) {
        if(date != null) {
            SimpleDateFormat format = new SimpleDateFormat(dateFormat);
                return format.format(date);
        }
        return "";
    }

    public static Date dateAdd(int interval, Date date, int n) {
        long time = date.getTime() / 1000L;
        switch(interval) {
            case 1:
                time += (long)(n * 86400);
                break;
            case 2:
                time += (long)(n * 604800);
                break;
            case 3:
                time += (long)(n * 2678400);
                break;
            case 4:
                time += (long)(n * 31536000);
                break;
            case 5:
                time += (long)(n * 3600);
                break;
            case 6:
                time += (long)(n * 60);
                break;
            case 7:
                time += (long)n;
                default:
                    time += (long)n;
                break;

        }

        Date result = new Date();
        result.setTime(time * 1000L);
        return result;
    }



    public static Date getDateByUnixTime(int unixTime) {
        return new Date((long)unixTime * 1000L);
    }

    public static long getUnixTimeLong() {
        return (long)getUnixTimeByDate(new Date());
    }

    public static int getCurrentUnixTime() {
        return getUnixTimeByDate(new Date());
    }

    public static int getUnixTimeByDate(Date date) {
        return (int)(date.getTime() / 1000L);
    }

    public static long getUnixTimeLong(Date date) {
        return date.getTime() / 1000L;
    }


    public static String formatDateByUnixTime(long unixTime, String dateFormat) {
        return dateFormat(new Date(unixTime * 1000L), dateFormat);
    }

}
