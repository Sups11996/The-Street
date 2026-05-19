package com.the_street.the_street.model;

import java.sql.Timestamp;

/**
 * Model class representing a row in the 'requests' table.
 * Schema: request_id, receiver_id (FK→users), title, category (ENUM),
 *         quantity, urgency (ENUM: LOW/MEDIUM/HIGH), description,
 *         location, status (ENUM: PENDING/ACCEPTED/FULFILLED/CANCELLED),
 *         created_at
 */
public class Request {

    private int requestId;
    private int receiverId;
    private String title;
    private String category;   // FOOD, CLOTHES, ESSENTIALS, OTHER
    private String quantity;
    private String urgency;    // LOW, MEDIUM, HIGH
    private String description;
    private String location;
    private String status;     // PENDING, ACCEPTED, FULFILLED, CANCELLED
    private Timestamp createdAt;

    // ── Getters & Setters ─────────────────────────────────────────────

    public int getRequestId()               { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getReceiverId()                { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public String getTitle()                { return title; }
    public void setTitle(String title)      { this.title = title; }

    public String getCategory()               { return category; }
    public void setCategory(String category)  { this.category = category; }

    public String getQuantity()               { return quantity; }
    public void setQuantity(String quantity)  { this.quantity = quantity; }

    public String getUrgency()              { return urgency; }
    public void setUrgency(String urgency)  { this.urgency = urgency; }

    public String getDescription()                { return description; }
    public void setDescription(String description){ this.description = description; }

    public String getLocation()               { return location; }
    public void setLocation(String location)  { this.location = location; }

    public String getStatus()               { return status; }
    public void setStatus(String status)    { this.status = status; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)   { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Request{requestId=" + requestId + ", receiverId=" + receiverId
                + ", title='" + title + "', status='" + status + "'}";
    }
}