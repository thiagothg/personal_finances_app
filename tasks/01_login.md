## Feature 01 - Login

### Requirements

- [ ] Create login page
- [ ] Create login controller
- [ ] Create login usecase
- [ ] Create login repository
- [ ] Create login datasource
- [ ] Create login provider
- [ ] Create login route
- [ ] Create login navigation
- [ ] Create login tests
- [ ] Create login documentation

### Flow of login

- User open the app
- User enter email and password
- User click on login button
- App validate the credentials
- If the credentials are valid, app navigate to home page
- If the credentials are invalid, app show error message
- If the user is already logged in, app navigate to home page

### Architecture

- UI -> Controller -> UseCase -> Repository -> Datasource -> API
- Controller use ref to get the usecase
- UseCase use ref to get the repository
- Repository use ref to get the datasource
- Datasource use ref to get the API

create this flow using the ref pattern on Architecture.md and changes this if not correct to follow rules.
