import "rails_admin/src/rails_admin/base";
RailsAdmin.on("rails_admin.dom.ready", function () {
  const script1 = document.createElement("script");
  script1.src = "https://cdn.jsdelivr.net/npm/chart.js";
  document.body.appendChild(script1);

  const script2 = document.createElement("script");
  script2.src = "https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels";
  document.body.appendChild(script2);
});
