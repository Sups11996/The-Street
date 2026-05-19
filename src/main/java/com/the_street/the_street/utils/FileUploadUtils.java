package com.the_street.the_street.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

public class FileUploadUtils {

    private static final long MAX_SIZE = 5 * 1024 * 1024; // 5 MB

    /**
     * Validates and saves a profile image Part.
     * @return relative path like "uploads/filename.jpg", or "" if no file provided.
     * @throws IllegalArgumentException if file type or size is invalid.
     */
    public static String saveProfileImage(Part filePart, ServletContext ctx) throws IOException {
        if (filePart == null || filePart.getSize() == 0) return "";

        String contentType = filePart.getContentType();
        if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)
                && !"image/jpg".equals(contentType)) {
            throw new IllegalArgumentException("Only JPG, JPEG, and PNG files are allowed.");
        }

        if (filePart.getSize() > MAX_SIZE) {
            throw new IllegalArgumentException("File size must be less than 5MB.");
        }

        String uploadPath = ctx.getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String uniqueName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        filePart.write(uploadPath + File.separator + uniqueName);
        return "uploads/" + uniqueName;
    }
}
