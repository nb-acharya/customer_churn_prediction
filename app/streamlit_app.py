import streamlit as st
import pandas as pd
import joblib

# Load saved model, scaler, and expected columns
model = joblib.load('models/churn_model.pkl')
scaler = joblib.load('models/scaler.pkl')
model_columns = joblib.load('models/model_columns.pkl')

# --- User inputs (top 6 fields) ---
tenure = st.slider("Tenure (months)", 0, 72, 12)
contract = st.selectbox("Contract Type", ["Month-to-month", "One year", "Two year"])
internet_service = st.selectbox("Internet Service", ["DSL", "Fiber optic", "No"])
monthly_charges = st.number_input("Monthly Charges ($)", min_value=0.0, max_value=200.0, value=70.0)
online_security = st.selectbox("Online Security", ["Yes", "No"])
payment_method = st.selectbox("Payment Method", 
    ["Electronic check", "Mailed check", "Bank transfer (automatic)", "Credit card (automatic)"])

predict_button = st.button("Predict Churn")

def build_input_df(tenure, contract, internet_service, monthly_charges, 
                    online_security, payment_method):
    
    # Start with defaults for every raw field the pipeline expects
    data = {
        'SeniorCitizen': 0,
        'Partner': 0,
        'Dependents': 0,
        'tenure': tenure,
        'PhoneService': 1,
        'MultipleLines': 0,
        'OnlineSecurity': 1 if online_security == 'Yes' else 0,
        'OnlineBackup': 0,
        'DeviceProtection': 0,
        'TechSupport': 0,
        'StreamingTV': 0,
        'StreamingMovies': 0,
        'PaperlessBilling': 1,
        'MonthlyCharges': monthly_charges,
        'TotalCharges': monthly_charges * tenure,  # approximation, same logic as real data
    }
    
    # Engineered features (recreate same logic as feature engineering notebook)
    service_flags = [data['OnlineSecurity'], data['OnlineBackup'], data['DeviceProtection'],
                      data['TechSupport'], data['StreamingTV'], data['StreamingMovies']]
    data['TotalServices'] = sum(service_flags)
    data['AvgChargePerService'] = data['MonthlyCharges'] / (data['TotalServices'] + 1)
    data['IsNewCustomer'] = 1 if tenure <= 6 else 0
    data['IsBundledCustomer'] = 1 if data['TotalServices'] >= 3 else 0
    data['IsMonthToMonth'] = 1 if contract == 'Month-to-month' else 0
    
    df = pd.DataFrame([data])
    
    # OneHot columns - manually set based on selectbox values
    df['gender_Male'] = 0  # default, not collected in form
    df['InternetService_Fiber_optic'] = 1 if internet_service == 'Fiber optic' else 0
    df['InternetService_No'] = 1 if internet_service == 'No' else 0
    df['Contract_One_year'] = 1 if contract == 'One year' else 0
    df['Contract_Two_year'] = 1 if contract == 'Two year' else 0
    df['PaymentMethod_Credit_card_automatic'] = 1 if payment_method == 'Credit card (automatic)' else 0
    df['PaymentMethod_Electronic_check'] = 1 if payment_method == 'Electronic check' else 0
    df['PaymentMethod_Mailed_check'] = 1 if payment_method == 'Mailed check' else 0
    
    # Tenure bucket - recreate same bucket logic
    if tenure <= 12:
        bucket = '0-12'
    elif tenure <= 24:
        bucket = '13-24'
    elif tenure <= 48:
        bucket = '25-48'
    elif tenure <= 60:
        bucket = '49-60'
    else:
        bucket = '61-72'
    
    for b in ['13-24', '25-48', '49-60', '61-72']:
        df[f'TenureBucket_{b}'] = 1 if bucket == b else 0
    
    # Reindex to match training columns exactly (fills any missing with 0, drops extras)
    df = df.reindex(columns=model_columns, fill_value=0)
    
    return df


if predict_button:
    input_df = build_input_df(tenure, contract, internet_service, 
                                monthly_charges, online_security, payment_method)
    
    # Scale the same numeric columns as training
    numeric_cols = ['tenure', 'MonthlyCharges', 'TotalCharges', 'AvgChargePerService']
    input_df[numeric_cols] = scaler.transform(input_df[numeric_cols])
    
    # Predict probability
    proba = model.predict_proba(input_df)[0][1]
    prediction = "Likely to Churn" if proba >= 0.4 else "Likely to Stay"
    
    st.subheader(f"Prediction: {prediction}")
    st.write(f"Churn Probability: {proba:.2%}")
    
    if proba >= 0.4:
        st.warning("⚠️ This customer is at risk. Consider retention offers.")
    else:
        st.success("✅ This customer looks stable.")