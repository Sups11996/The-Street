package com.the_street.the_street.dao;

import com.the_street.the_street.model.Request;
import java.util.ArrayList;

/**
 * Interface defining all data-access operations for the requests table.
 * RequestDAO must implement every method here.
 */
public interface RequestInterface {

    // ── Receiver CRUD ──────────────────────────────────────────────────

    /** Insert a new request. Returns true on success. */
    boolean insertRequest(Request request);

    /** Get all requests belonging to a specific receiver. */
    ArrayList<Request> getRequestsByReceiverId(int receiverId);

    /** Get one request by its primary key. */
    Request getRequestById(int requestId);

    /** Update title, category, quantity, urgency, description, location.
     *  Only allowed when status is PENDING. */
    boolean updateRequest(Request request);

    /** Cancel a request (set status = CANCELLED). */
    boolean cancelRequest(int requestId);

    /** Confirm receipt of a matched donation (set status = FULFILLED). */
    boolean confirmReceipt(int requestId);

    // ── Status helpers ─────────────────────────────────────────────────

    /** Update the status of a request directly. */
    boolean updateRequestStatus(int requestId, String status);

    // ── Dashboard counts ───────────────────────────────────────────────

    /** Count all requests for a receiver. */
    int countRequestsByReceiverId(int receiverId);

    /** Count requests for a receiver filtered by status. */
    int countRequestsByStatus(int receiverId, String status);
}
