require 'session' 

module Auth

    def open_database()
        db = SQLite3::Database.new('db/db.sqlite3')
        db.results_as_hash = true
        return db
    end

    def get_user_by_username(username, db)
        users = db.execute("SELECT * FROM users WHERE username = '#{username}'")
        if users.length == 0 
            return nil
        end
        return users[0] 
    end

    def register_user(username, password, db)
        password_encrypted = BCrypt::Password.create(password)
        result = db.execute("INSERT INTO users(username, password) VALUES(?, ?)", [username, password_encrypted])
        id = db.execute("SELECT id FROM users WHERE username = '#{username}'")[0]["id"]
        session[:user_id] = id
    end

    def login_user(username, password, db)
        users = db.execute("SELECT * FROM users WHERE username = '#{username}'")
        if users.length == 0 
            return -1 
        end
    
        users = users[0]
        if BCrypt::Password.new(users['password']) == password
            id = users['id']
            session[:user_id] = id 
            return id
        end

        return -1
    end

    def logout_user()
        session[:user_id] = nil
    end

    def get_user_id()
        id = session[:user_id]
        if id == nil
            return -1
        end
        return id
    end 

    def is_logged_in()
        return get_user_id() != -1
    end

    def get_result(db) 
        result = db.execute("SELECT * FROM notes WHERE user_id=?", [session[:user_id]])
    end

    def create_note(db, content,id)
        db.execute("INSERT INTO notes (user_id, content) VALUES (?,?)", [id, content])
    end

    def get_result_note(db)
        note_result = db.execute("SELECT user_id FROM notes WHERE id=?", [note_id])
    end
        

    def delete_note(db)
        if note_result.first["user_id"] == session[:user_id]
            db.execute("DELETE FROM notes WHERE id=?", [note_id])
            redirect('/homepage')
        end
    else
        redirect('/homepage')
    end 
end

