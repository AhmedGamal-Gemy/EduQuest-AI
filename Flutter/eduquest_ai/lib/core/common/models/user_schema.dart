/*
    !Get: /api/v1/students/{id} ............. Get user details. Allowed: Self, Instructor (for students), or Superuser.
      Parameters: id*: string($uuid)
      Responses: idstringuuid && emailstringemail && is_activeExpand allboolean && is_superuserExpand allboolean && is_verifiedExpand allboolean && first_nameExpand all(string | null) && last_nameExpand all(string | null) && roleExpand allstring


*/