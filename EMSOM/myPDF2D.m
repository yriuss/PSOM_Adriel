function p= myPDF2D(X,M,SIGMA)
%d=2;
  d=length(X);
  try
  result = pyrunfile("det.py", "result", data = py.numpy.array(SIGMA) );
  catch ex
      result = 0;
  end;
    
  p = (((((2*pi)^(d))*det(result))^(-(1/2)))   *  exp((-1/2)*(X-M) * pinv(SIGMA) * (X-M)'));
%p = (((((2*pi)^(d)))^(-(1/2)))   *  exp((-1/2)*(X-M) * pinv(SIGMA) * (X-M)'));
end