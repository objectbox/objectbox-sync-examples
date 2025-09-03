/*
 * Copyright 2024 ObjectBox Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.objectbox.example;

import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.annotation.Sync;
import java.math.BigDecimal;
import io.objectbox.annotation.ExternalType;
import io.objectbox.annotation.ExternalPropertyType;
import java.util.Arrays;
import java.util.Date;

@Sync
@Entity
public class Task {

    @Id
    private long id;
    private String text;
    private Date dateCreated;
    private Date dateFinished;
    String ownerEmail;

    // External mappings
    @ExternalType(ExternalPropertyType.FLEX_VECTOR)
    private Object flexList;

    @ExternalType(ExternalPropertyType.MONGO_REGEX)
    private String[] regex;

    @ExternalType(ExternalPropertyType.DECIMAL_128)
    private String decimalString;

    BigDecimal getBigDecimal() {
        return new BigDecimal(decimalString);
    }

    // ✅ Required by ObjectBox
    public Task() { }

    /** Convenience: text only */
    public Task(String text) {
        this(text, null);
    }

    /** Matches call site in TasksSyncDB: new Task(text, currentUserEmail) */
    public Task(String text, String ownerEmail) {
        this(text, ownerEmail, null, null, null);
    }

    public Task(String text,String ownerEmail, Object flexList, String[] regex, String decimalString) {
        this.text = text;
        this.dateCreated = new Date();
        this.dateFinished = new Date(0);
        this.ownerEmail = ownerEmail;
        this.flexList = flexList;
        this.regex = regex;
        this.decimalString = decimalString;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public Date getDateFinished() {
        return dateFinished;
    }

    public void setDateFinished(Date dateFinished) {
        this.dateFinished = dateFinished;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Object getFlexList() { return flexList; }
    public void setFlexList(Object flexList) { this.flexList = flexList; }

    public String[] getRegex() { return regex; }
    public void setRegex(String[] regex) { this.regex = regex; }

    public String getDecimalString() { return decimalString; }
    public void setDecimalString(String decimalString) { this.decimalString = decimalString; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", text='" + text + '\'' +
                ", createdDate=" + dateCreated +
                ", finishedDate=" + dateFinished +
                ", ownerEmail='" + ownerEmail + '\'' + 
                ", flexList=" + flexList +
                ", regex=" + Arrays.toString(regex) +
                ", decimalString='" + decimalString + '\'' +
                '}';
    }
}

