# Import packages
import os
import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_bootstrap_components as dbc
from dash.dependencies import Input, Output
import base64

import pandas as pd
import plotly.express as px

# Initialize app
external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]
app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
# app = dash.Dash()

# Load external datasets
df_states_info = pd.read_csv("dash/state_summary.csv").sort_values(["state_name"])

# Create dropdown menu data
dropdown_dict = []
for i in range(len(df_states_info)):
    dict_temp = {}
    dict_temp["label"] = df_states_info["state_name"].iloc[i]
    dict_temp["value"] = df_states_info["state_abbrev"].str.lower().iloc[i]
    dropdown_dict.append(dict_temp)
# dropdown_dict = df_states_info.sort_values(["state_name"]).set_index("state_name").to_dict()["state_abbrev"]

# Define app layout
app.layout = html.Div([
    html.Div([
        html.H1(
            children="Gerrymandering"
        ),
        html.H3(
            children="How Machine Learning Can Improve Election Quality"
        ),
    ]),
    html.Div([
        html.P(
            children='''
                The United States is in a unique situation where there are only two political parties.
                Other democratic countries tend to have more parties that all keep each other in check,
                but in the United States, every loss for your opponent is a win for you.
            '''
        ),
        html.P(
            children='''
                One such strategy that arises out of this two-party system is redrawing the electoral map to
                either favor yourself or disfavor your opponent, also known as "gerrymandering". Since the
                population flutucates over time, every 10 years a state is able to redraw their electoral
                districts. The party in power at this time can redraw these districts however they'd like,
                as long as the district is coninuous (no jumping around) and that all the districts have
                even populations.
            '''
        ),
        html.H6(
            children='''
                NOTE: North Carolina is the only state currently fitted with the Equal-Sized K-Means algorithm.
            '''
        ),
    ]),
    html.Div([
        dcc.Dropdown(
            id="state-dropdown",
            options=dropdown_dict,
            value="nc",
        ),
    ], style={'width': '20%', 'display': 'inline-block'}),
    html.Div([
        html.Div([
            html.H5(
                children="Current Congressional Districts"
            ),
            html.Img(id="original-district"),
            html.H5(
                children="Equal-Sized K-Means Districts"
            ),
            html.Img(id="kmeans-district"),
        ], style={'width': '24%', 'display': 'inline-block'}),
        html.Div([
            dcc.Graph(
                id="choropleth",
                figure=px.choropleth(
                    df_states_info,
                    locations="state_abbrev",
                    color="seats",
                    locationmode="USA-states",
                    scope="usa",
                    hover_name="state_name",
                    hover_data=[
                        "seats"
                    ],
                    title="Number of Congressional Seats by State",
                    labels={
                        "state_abbrev":"State Abbreviation",
                        "seats":"Congressional Seats",
                    },
                    template="plotly_white",
                )
            ),
            # dcc.Graph(
            #     id="histogram",
            #     figure=px.histogram(
            #         df_states_info,
            #         x="pop_per_seat",
            #         nbins=20,
            #         title="Population Distribution of Congressional Districts",
            #         labels={
            #             "pop_per_seat":"Population per Congressional District",
            #             "count":"Number of States",
            #         },
            #         template="plotly_white",
            #     )
            # )
        ], style={'width': '74%', 'display': 'inline-block'})
    ])
])

@app.callback(
    dash.dependencies.Output("original-district", "src"),
    [dash.dependencies.Input("state-dropdown", "value")])
def update_original_district(value):
    try:
        filename = value + "_cd.png"
    except TypeError:
        filename = "cd.png"
    return app.get_asset_url(filename)

@app.callback(
    dash.dependencies.Output("kmeans-district", "src"),
    [dash.dependencies.Input("state-dropdown", "value")])
def update_original_district(value):
    try:
        filename = value + "_fit.png"
    except TypeError:
        filename = "fit.png"
    return app.get_asset_url(filename)

# app.css.append_css({
#     "external_url": "https://codepen.io/chriddyp/pen/bWLwgP.css"
# })

# Run app
if __name__ == '__main__':
    app.run_server(debug=False)
