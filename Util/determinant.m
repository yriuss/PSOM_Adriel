function d = determinant(a)
%DETERMINANT computes determinant using naive algorithm
%   D = DETERMINANT(A) computes the determinant of the square matrix A
%   using the Laplace expansion. MATLAB's built-in DET is likely to be
%   preferable for most applications, but this function gives an exact
%   answer for small matrices of small integers.
if min(size(a)) == 1
      if max(size(a)) == 1
          d = a;
      else
          error('determinant:nonSquare', 'A must be square and 2D');
      end
else
      row1 = a(1, :);
      rows2etc = a(2:end, :);
      sign = 1;
      d = 0;
      for ii = 1:length(row1)
          ii
          minor = [rows2etc(:, 1:ii-1) rows2etc(:, ii+1:end)];
          d = d + sign * row1(ii) * determinant(minor);
          sign = -sign;
      end
end
end