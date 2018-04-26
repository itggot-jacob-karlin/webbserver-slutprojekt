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

    def get_result() 
        result = db.execute("SELECT * FROM notes WHERE user_id=?", [session[:user_id]])
    end

    def create_note()
        note = db.execute("INSERT INTO notes (user_id, content) VALUES (?,?)", [session[:user_id], content])
    end
end

