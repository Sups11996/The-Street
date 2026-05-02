package com.the_street.the_street.utils;

import java.sql.Connection;

public class DBTest {
    public static void main(String[] args) {
        try{
            Connection conn = DBConnection.getConnection();

            if (conn != null){
                System.out.println("Database connection established successfully");
            }

        } catch (Exception e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
