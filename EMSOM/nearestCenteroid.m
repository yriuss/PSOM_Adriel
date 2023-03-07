function c = nearestCenteroid(centroids)

c = find(centroids == min(centroids));
c = c(1)
end

